# Create new mod
function newmod {
    cdgo "$1" || return
    git pull origin master -q
    if [[ -f "$HOME/OBS/home:fusion809/openra-$2/openra-$2.spec" ]]; then
         printf "%s\n" "I've already packaged openra-$1, so returning." && return
    else
         if ! [[ -d "$HOME/OBS/home:fusion809/openra-$2" ]]; then
              cdobsh && osc mkpac "openra-$2" && cd - || return
         fi
         # OpenRA latest engine version
         latest_engine_version=$(grep '^ENGINE\_VERSION' < cat mod.config | cut -d '"' -f 2)
         packaged_engine_version=$(grep "define engine\_version" < $HOME/OBS/home:fusion809/openra-dr/openra-dr.spec | cut -d ' ' -f 3)
         packaged_commit_number=$(vere openra-dr)
         latest_commit_no=$(latest_commit_number)
         packaged_commit_hash=$(come openra-dr)
         latest_commit_hash=$(latest_commit_on_branch)

         cp $OBSH/openra-dr/openra-dr "$OBSH/openra-$2/openra-$2"
         cp $OBSH/openra-dr/openra-dr.spec "$OBSH/openra-$2/openra-$2.spec"
         cp $OBSH/openra-dr/openra-dr.install "$OBSH/openra-$2/openra-$2.install"
         cp $OBSH/openra-dr/openra-dr.desktop "$OBSH/openra-$2/openra-$2.desktop"
         # Using Generals appdata as it is missing a few lines I am not providing for new mods
         cp $OBSH/openra-gen/openra-gen.appdata.xml "$OBSH/openra-$2/openra-$2.appdata.xml"
         cp $OBSH/openra-dr/_service "$OBSH/openra-$2/_service"
         cp $OBSH/openra-dr/PKGBUILD "$OBSH/openra-$2/PKGBUILD"

         sed -i -e "s/-dr/-$2/g" "$OBSH/openra-$2/openra-$2"*
         sed -i -e "s/-dr/-$2/g" "$OBSH/openra-$2/PKGBUILD"
         sed -i -e "s/=dr/=$2/g" "$OBSH/openra-$2/openra-$2"
         sed -i -e "s|mods/dr|mods/$2|g" "$OBSH/openra-$2/openra-$2"*
         sed -i -e "s|mods/dr|mods/$2|g" "$OBSH/openra-$2/PKGBUILD"
         # Change GitHub repository
         sed -i -e "s|drogoganor/DarkReign|$3|g" "$OBSH/openra-$2/openra-$2"*
         sed -i -e "s|drogoganor/DarkReign|$3|g" "$OBSH/openra-$2/PKGBUILD"
         sed -i -e "s|MustaphaTR/Generals-Alpha|$3|g" "$OBSH/openra-$2/openra-$2"*
         sed -i -e "s|MustaphaTR/Generals-Alpha|$3|g" "$OBSH/openra-$2/PKGBUILD"
         # Change repo name
         sed -i -e "s|DarkReign|$1|g" "$OBSH/openra-$2/openra-$2"*
         sed -i -e "s|DarkReign|$1|g" "$OBSH/openra-$2/PKGBUILD"
         # Change original game name mentioned in desktop config file, appdata, etc.
         sed -i -e "s|Dark Reign: The Future of War|$4|g" "$OBSH/openra-$2/openra-$2"*
         sed -i -e "s|Dark Reign: The Future of War|$4|g" "$OBSH/openra-$2/PKGBUILD"
         sed -i -e "s|Command & Conquer: Generals|$4|g" "$OBSH/openra-$2/openra-$2"*
         sed -i -e "s|Command & Conquer: Generals|$4|g" "$OBSH/openra-$2/PKGBUILD"
         # Serves as what comes after OpenRA - in Name line of desktop config file
         sed -i -e "s|Dark Reign|$5|g" "$OBSH/openra-$2/openra-$2"*
         sed -i -e "s|Dark Reign|$5|g" "$OBSH/openra-$2/PKGBUILD"
         
         sed -i -e "s/$packaged_commit_number/$latest_commit_no/g" "$OBSH/openra-$2"/{openra-"$2".spec,PKGBUILD}
         sed -i -e "s/$packaged_commit_hash/$latest_commit_hash/g" "$OBSH/openra-$2"/{openra-"$2".spec,PKGBUILD}
         sed -i -e "s/$packaged_engine_version/$latest_engine_version/g" "$OBSH/openra-$2"/{openra-"$2".spec,PKGBUILD}
         if [[ -f $GHUBO/yr/mods/yr/logo.png ]]; then
              sed -i -e "s|icon.png|logo.png|g" "$OBSH/openra-$2"/{openra-"$2".spec,PKGBUILD}
         fi
         make clean
         make
         tar czvf "$HOME/OBS/home:fusion809/openra-$2/engine-${latest_engine_version}.tar.gz" engine
         cdobsh openra-"$2" || return
         osc add engine-"${latest_engine_version}".tar.gz
         cd - || return
         cdobsh openra-"$2" || return
         read "yn?Edit the description (line 70) as it presently is written for Dark Reign.\n Type y or yes and then enter to proceed.\n"
         vsp
         osc build openSUSE_Tumbleweed --noverify
    fi
}
