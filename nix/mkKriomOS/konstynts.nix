let
  systemd = rec {
    stateDirectory = "/var/lib";
    runtimeDirectory = "/run";
    dynamicUserStateDirectory = stateDirectory + "/private";
    dynamicUserRuntimeDirectory = runtimeDirectory + "/private";
  };

in
{
  fileSystem = {
    niks = rec {
      beisDyrektori = "/niks";
      podzDyrektori = beisDyrektori + "/podz";
    };

    niks = rec {
      stateDirectory = "/etc/nix";
      priKriad = "/etc/nix/priKriad";
    };

    inherit systemd;

    yggdrasil = rec {
      subDirName = "yggdrasil";
      stateDirectory = systemd.dynamicUserStateDirectory
        + "/" + subDirName;

      runtimeDirectory = systemd.runtimeDirectory
        + "/" + subDirName;

      preKriomJson = runtimeDirectory + "/preKriom.json";
      priKriadJson = stateDirectory + "/priKriad.json";
      combinedConfigJson = stateDirectory + "/combinedConfig.json";

      interfaceName = "yggtun";
    };
  };

  network = {
    ula48Suffix = {
      wifi = rec {
        subnet = ":1000:1000";
        address = subnet + ":1000::";
        radvdPrefix = subnet + "::/64";
      };
    };

    yggdrasil = rec {
      subnet = "200::";
      prefix = 7;
      namespace = subnet + "/" + (toString prefix);
      ports = {
        multicast = 9001;
        linkLocalTCP = 10001;
      };
    };

    nat64 = {
      pool = rec {
        subnet = "64:ff9b::";
        prefix = 96;
        full = subnet + "/" + (toString prefix);
      };
    };

    niks = {
      serve = {
        ports = {
          external = 5000;
          internal = 4999;
        };
      };

      store = {
        http = {
          ports.external = 8000;
        };
      };
    };

  };

}
