# OpenRA mod Nixpkg updater
# sha256 nix-prefetch-url lines are commented out as they do not give the correct sha256
function nixoup {
	# Change to mod source directory
	cd $GHUBO/"$1"
	# Determine mod name
	MOD=$(grep "^MOD_ID" < mod.config | cut -d '"' -f 2)
	# Print mod name (largely to check for errors)
	printf '\e[1;32m%-6s\e[m\n' "Mod name is $MOD."
	# Stash changes, so that pull works fine
	git stash -q || { printf '\e[1;31m%-6s\e[m\n' "git stashin' failed, so exiting." && return }
	# Pull upstream changes
	git pull origin $(git-branch) -q || { printf '\e[1;31m%-6s\e[m\n' "git pullin' on branch $(git-branch) failed." && return }
	# Present commit number
	numbc=$(git rev-list --branches $(git-branch) --count)
	printf '\e[1;32m%-6s\e[m\n' "Current commit number (numbc) is ${numbc}."
	# Present commit hash
	commitc=$(latest_commit_on_branch)
	printf '\e[1;32m%-6s\e[m\n' "Current commit hash (commitc) is ${commitc}."
	# Engine version
	if ( grep "^AUTOMATIC_ENGINE_SOURCE" < mod.config | grep -v 'ENGINE_VERSION' &> /dev/null ) && ( grep '^AUTOMATIC_ENGINE_MANAGEMENT="True"' < mod.config &> /dev/null); then
		enginec=$(grep "^AUTOMATIC_ENGINE_SOURCE" < mod.config | cut -d '.' -f 2 | cut -d '/' -f 5)
	else
		enginec=$(grep "^ENGINE_VERSION" < mod.config | cut -d '"' -f 2)
		printf '\e[1;32m%-6s\e[m\n' "Current engine version (enginec) is ${enginec}."
		if [[ $enginec == "{DEV_VERSION}" ]]; then
			git -C $GHUBO/OpenRA pull origin bleed
			enginec=$(git -C $GHUBO/OpenRA log | head -n 1 | cut -d ' ' -f 2)
		fi
	fi
	# Presently packaged versions
	enginen=$(grep '^\s*engine-version' < $NIXPKGS/pkgs/games/openra-$MOD/default.nix | cut -d '"' -f 2)
	printf '\e[1;32m%-6s\e[m\n' "Presently packaged engine version (enginen) is ${enginen}."
	numbn=$(grep "^\s*version" < $NIXPKGS/pkgs/games/openra-$MOD/default.nix | cut -d '"' -f 2)
	printf '\e[1;32m%-6s\e[m\n' "Presently packaged commit number (numbn) is ${numbn}."
	commitn=$(grep "^\s*rev" < $NIXPKGS/pkgs/games/openra-$MOD/default.nix | head -n 1 | cut -d '"' -f 2)
	printf '\e[1;32m%-6s\e[m\n' "Presently packaged commit hash (commitn) is ${commitn}."
	if [[ ${commitn} == ${commitc} ]]; then
		return
	fi
	# Mod itself
	owner1=$(grep "owner" < $NIXPKGS/pkgs/games/openra-${MOD}/default.nix | head -n 1 | cut -d '"' -f 2)
	printf '\e[1;32m%-6s\e[m\n' "Mod repo's owner (owner1) is ${owner1}."
	repo1=$(grep "repo" < $NIXPKGS/pkgs/games/openra-${MOD}/default.nix | head -n 1 | cut -d '"' -f 2)
	printf '\e[1;32m%-6s\e[m\n' "Mod repo's name (repo1) is ${repo1}."
	# Nixpkg checksum for mod's latest commit's tar archive
	#nix-prefetch-url https://github.com/$owner1/$repo1/archive/${commitc}.tar.gz &> /tmp/sha256_1
	#sha256 for this archive
	#sha256_1=$(cat /tmp/sha256_1 | tail -n 1)
	#printf '\e[1;32m%-6s\e[m\n' "Checksum for mod's latest commit's tar archive (sha256_1) is ${sha256_1}."
	# Engine
	# Owner name
    owner2c=$(grep "^AUTOMATIC_ENGINE_SOURCE" < mod.config | cut -d '.' -f 2 | cut -d '/' -f 2)
	printf '\e[1;32m%-6s\e[m\n' "New engine owner's name (owner2c) is ${owner2c}."
	owner2n=$(grep "owner" < $NIXPKGS/pkgs/games/openra-${MOD}/default.nix | head -n 3 | tail -n 1 | cut -d '"' -f 2)
	printf '\e[1;32m%-6s\e[m\n' "Packaged engine owner's name (owner2n) is ${owner2n}."
	# Repo name
	repo2c=$(grep "^AUTOMATIC_ENGINE_SOURCE" < mod.config | cut -d '.' -f 2 | cut -d '/' -f 3)
	printf '\e[1;32m%-6s\e[m\n' "New engine repo's name (repo2c) is ${repo2c}."
	repo2n=$(grep "repo" < $NIXPKGS/pkgs/games/openra-${MOD}/default.nix | head -n 3 | tail -n 1 | cut -d '"' -f 2)
	printf '\e[1;32m%-6s\e[m\n' "Packaged engine repo's name (repo2n) is ${repo2n}."
	# Checksum for tar repo2's archive
	#nix-prefetch-url https://github.com/$owner2/$repo2/archive/${enginec}.tar.gz &> /tmp/sha256_2
	#sha256_2=$(cat /tmp/sha256_2 | tail -n 1)
	# Below two lines are from the first sed to appear below
	#			   -e "26s|sha256 = \".*\"|sha256 = \"${sha256_1}\"|" \
	#			   -e "33s|sha256 = \".*\"|sha256 = \"${sha256_2}\"|" \
	# This line is from the second sed
	# 			   -e "26s|sha256 = \".*\"|sha256 = \"${sha256_1}\"|" \
	# printf '\e[1;32m%-6s\e[m\n' "Checksum for the engine's tar archive (sha256_2) is ${sha256_2}."
	# rm /tmp/sha256*
    # Update engine and mod, if needed, otherwise just update the mod itself
	if ! [[ ${enginen} == ${enginec} ]]; then
		sed -i -e "13s|${numbn}|${numbc}|" \
		       -e "25s|${commitn}|${commitc}|" \
		       -e "14s|${enginen}|${enginec}|" \
			   -e "30s|${owner2n}|${owner2c}|" \
			   -e "31s|${repo2n}|${repo2c}|" \
			   -e "26s|sha256 = \".*\"|sha256 = \"1q5jbkpyhz1p0n7w0v8g6l8p3xcbnmcn0hvf3wxxs48n6fjyw6f9\"|" \
			   -e "33s|sha256 = \".*\"|sha256 = \"1q5jbkpyhz1p0n7w0v8g6l8p3xcbnmcn0hvf3wxxs48n6fjyw6f2\"|" \
			   $NIXPKGS/pkgs/games/openra-${MOD}/default.nix
	else
		sed -i -e "13s|${numbn}|${numbc}|g" \
		       -e "25s|${commitn}|${commitc}|g" \
			   -e "30s|${owner2n}|${owner2c}|" \
			   -e "31s|${repo2n}|${repo2c}|" \
			   -e "26s|sha256 = \".*\"|sha256 = \"1q5jbkpyhz1p0n7w0v8g6l8p3xcbnmcn0hvf3wxxs48n6fjyw694\"|" \
			   $NIXPKGS/pkgs/games/openra-${MOD}/default.nix
	fi
	cd "/data/GitHub/mine/packaging/nixpkgs/pkgs/games/openra-${MOD}"
	nixb
	# Build package, to get sha256
	printf "You will have to update the sha256 field of /data/GitHub/mine/packaging/nixpkgs/pkgs/games/openra-${MOD}/default.nix,\n"
	printf 'based on the output of nix-env -f $NIXPKGS -iA openra-'
	printf "${MOD}\n"
}