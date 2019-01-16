# This function is from msteen @ GitHub and taken from NixOS/nixpkgs#53878
function nix-prefetch {

[[ $1 =~ ^(-v|--version)$ ]] && echo '@version@' && exit
if
  [[ $1 =~ ^(-h|--help)$ ]] && help_ret=0 || ! {
    help_ret=1
    [[ $1 =~ ^(-f|--force)$ ]] && force=1 && shift || force=0
    (( $# == 2 )) && nixpkgs=$1 && shift || nixpkgs='<nixpkgs>'
    (( $# == 1 )) && expr=$1
  }
then
  cat <<'EOF' > "/dev/std$( (( ! help_ret )) && echo out || echo err )"
Print the output hash of the package sources.

Usage:
  nix-prefetch [--force] [<nixpkgs>] <sources>
  nix-prefetch -v | --version
  nix-prefetch -h | --help

Examples:
  nix-prefetch hello
  nix-prefetch --force hello
  nix-prefetch hello.src
  nix-prefetch '[ hello.src ]'
  nix-prefetch 'let name = "hello"; in pkgs.${name}'

Options:
  -f, --force    Recalculate the hash of the sources even if the hash was already correct.
  -h, --help     Show help message.
  -v, --version  Show version.
EOF
  exit $help_ret
fi

issue() {
  echo "Something unexpected happened:" >&2
  echo "$*" >&2
  echo "Please report an issue at: https://github.com/NixOS/nixpkgs/issues" >&2
  exit 1
}

preamble='let pkgs = import '"$nixpkgs"' { }; in with pkgs.lib;
  let
    x = with pkgs; '"$expr"';
    xs = if isList x then x else [ x ];
    srcs = concatMap (x: x.srcs or [ (x.src or x) ]) xs;
  in'

if (( force )); then
  validHashes='(map (const false) srcs)'
else
  lines=$(nix eval --raw '(
    '"$preamble"'
    concatStringsSep "\n" (map (src:
      concatStringsSep ":" (map toString [
        (src.outputHashAlgo or "sha256")
        (src.outputHash or "")
      ])
    ) srcs)
  )') || exit

  validHashes='['
  while IFS=':' read -r output_hash_algo output_hash; do
    validHashes+=" $( nix-hash --type "$output_hash_algo" --to-base32 "$output_hash" &>/dev/null && echo true || echo false )"
  done <<< "$lines"
  validHashes+=' ]'
fi

lines=$(nix eval --raw '(
  '"$preamble"'
  let
    dummyHashes = {
      md5    = "00000000000000000000000000";
      sha1   = "00000000000000000000000000000000";
      sha256 = "0000000000000000000000000000000000000000000000000000";
      sha512 = "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
    };
  in concatStringsSep "\n" (zipListsWith (src: validHash:
    let
      newSrc = if !validHash then src.overrideAttrs (oldAttrs: rec {
        outputHashAlgo = oldAttrs.outputHashAlgo or "sha256";
        outputHash = dummyHashes.${outputHashAlgo};
      }) else src;
    in concatStringsSep ":" (map toString [
      newSrc.drvPath
      (if validHash then 1 else 0)
      newSrc.outputHash
      (stringLength dummyHashes.${newSrc.outputHashAlgo})
    ])
  ) srcs '"$validHashes"')
)') || exit

while IFS=':' read -r drv_path valid_hash output_hash wanted_hash_size; do
  if err=$(nix-store --quiet --realize "$drv_path" 2>&1); then
    if (( ! valid_hash )); then
      issue "When provided a zeroed hash of the proper length it should always fail to build, but it succeeded."
    else
      echo "$output_hash"
    fi
  # Check for the new format:
  # https://github.com/NixOS/nix/commit/5e6fa9092fb5be722f3568c687524416bc746423
  elif ! grep --only-matching "[a-z0-9]\{$wanted_hash_size\}" <<< "$err" > >( [[ $err == *'hash mismatch'* ]] && tail -1 || head -1 ); then
    printf '%s\n' "$err" >&2
    issue "The only expected error message is a hash mismatch, but the grep for it failed."
  fi
done <<< "$lines"
}