{
  super
, pkgs
, pin1803
}:

rec {

  unity3d = super.stdenv.lib.overrideDerivation super.unity3d (attrs: {
    preFixup = ''
      find $unitydir -name PlaybackEngines -prune -o \( -type f -name \*.so -not -name libunity-nosuid.so \) -print | while read path
      do
        oldrpath=$(patchelf --print-rpath "$path")
        # TODO: Combine the three sed scripts into one.
        newrpath=$(echo $oldrpath | sed -e "s/:/\n/g" | sed -e "/^\/usr/d ; /^\/home/d ; /^\/tmp/d" | sed -e :a -e "/$/N; s/\n/:/; ta")
        if [[ "$newrpath" != "$oldrpath" ]]
        then
          patchelf --set-rpath "$newrpath" "$path" || echo Error setting rpath: $path
        fi
      done

    '' + attrs.preFixup;
  });

  unityEnv = pkgs.buildEnv {
    name = "env-unity";
    # Custome Unity3d environment.
    paths = with pin1803; [
      android-studio
      android-udev-rules
      androidndk
      androidsdk
    # androidenv.buildTools
    # androidenv.platformTools
      fsharp
      openjdk
      mono
      monodevelop
      steam-run-native
      unity3d
    ];
  };

}
