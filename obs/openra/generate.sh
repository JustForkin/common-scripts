# Dark Reign update
function genup {
    cdgo "$1"
    git pull origin master -q
    if [[ -f "$HOME/OBS/home:fusion809/openra-$2/openra-$2.spec" ]]; then
         printf "I've already packaged openra-$1, so exiting\n" && exit
    else
         if ! [[ -d "$HOME/OBS/home:fusion809/openra-$2" ]]; then
              cdobsh ; osc mkpac "openra-$2" ; cd -
         fi
         # OpenRA latest engine version
         enlv=$(cat mod.config | grep '^ENGINE\_VERSION' | cut -d '"' -f 2)
         specn=$(vere openra-dr)
         mastn=$(comno)
         specm=$(come openra-dr)
         comm=$(loge)

         cp $OBSH/openra-dr/openra-dr "$OBSH/openra-$2/openra-$2"
         cp $OBSH/openra-dr/openra-dr.spec "$OBSH/openra-$2/openra-$2.spec"
         cp $OBSH/openra-dr/openra-dr.install "$OBSH/openra-$2/openra-$2.install"
         cp $OBSH/openra-dr/openra-dr.desktop "$OBSH/openra-$2/openra-$2.desktop"
         # Using Generals appdata as it is missing a few lines I am not providing for new mods
         cp $OBSH/openra-gen/openra-gen.appdata.xml "$OBSH/openra-$2/openra-$2.appdata.xml"
         cp $OBSH/openra-dr/_service "$OBSH/openra-$2/_service"
         cp $OBSH/openra-dr/PKGBUILD "$OBSH/openra-$2/PKGBUILD"

         sed -i -e "s/-dr/-$2/g" "$OBSH/openra-$2/*"
         # Change GitHub repository
         sed -i -e "s|drogoganor/DarkReign|$3|g" "$OBSH/openra-$2/*"
         sed -i -e "s|MustaphaTR/Generals-Alpha|$3|g" "$OBSH/openra-$2/*"
         # Change repo name
         sed -i -e "s|DarkReign|$2|g" "$OBSH/openra-$2/*"
         # Change original game name mentioned in desktop config file, appdata, etc.
         sed -i -e "s|Dark Reign: The Future of War|$4|g" "$OBSH/openra-$2/*"
         sed -i -e "s|Command & Conquer: Generals|$4|g" "$OBSH/openra-$2/*"
         # Serves as what comes after OpenRA - in Name line of desktop config file
         sed -i -e "s|Dark Reign|$5|g" "$OBSH/openra-$2/*"
         
         sed -i -e "s/$specn/$mastn/g" $OBSH/openra-$2/{openra-$2.spec,PKGBUILD}
         sed -i -e "s/$specm/$comm/g" $OBSH/openra-$2/{openra-$2.spec,PKGBUILD}
         sed -i -e "s/$enpv/$enlv/g" $HOME/OBS/home:fusion809/openra-$2/{openra-$2.spec,PKGBUILD}
         make clean
         make
         tar czvf $HOME/OBS/home:fusion809/openra-$2/engine-${enlv}.tar.gz engine
         cdobsh openra-$2
         osc rm engine-${enpv}.tar.gz
         osc add engine-${enlv}.tar.gz
         cd -
         cdobsh openra-$2
         read "yn?Edit the description (line 70) as it presently is written for Dark Reign.\n Type y or yes and then enter to proceed.\n"
         vsp
         osc build openSUSE_Tumbleweed --noverify
    fi
}
