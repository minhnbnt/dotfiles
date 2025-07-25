let
  name = "minhnbnt";
  email = "${name}@gmail.com";
in

{
  programs.git = {
    enable = true;
    userEmail = email;
    userName = name;
  };

  programs.jujutsu = {
    enable = true;
    settings.user = {
      inherit email name;
    };
  };
}
