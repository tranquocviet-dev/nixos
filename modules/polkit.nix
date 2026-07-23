{
    security.polkit.extraConfig = ''
          polkit.addRule(function(action, subject) {
              if (action.id == "org.freedesktop.udisks2.filesystem-mount" &&
                  subject.isInGroup("wheel")) {
                  return polkit.Result.AUTH_ADMIN_KEEP;
              }
          });
    '';
}
