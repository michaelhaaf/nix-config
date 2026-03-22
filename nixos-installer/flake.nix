{
  description = "Minimal NixOS configuration for bootstrapping systems";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    disko.url = "github:nix-community/disko"; # Declarative partitioning and formatting
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      minimalSpecialArgs = {
        inherit inputs outputs;
        lib = nixpkgs.lib.extend (self: super: { custom = import ../lib { inherit (nixpkgs) lib; }; });
      };

      newConfig =
        name: disk: swapSize:
        (
          let
            diskSpecPath = ../hosts/common/disks/btrfs-disk.nix;
          in
          nixpkgs.lib.nixosSystem {
            stdenv.hostPlatform.system = "x86_64-linux";
            specialArgs = minimalSpecialArgs;
            modules = [
              inputs.disko.nixosModules.disko
              diskSpecPath
              {
                _module.args = {
                  inherit disk;
                  withSwap = swapSize > 0;
                  swapSize = builtins.toString swapSize;
                };
              }
              ./minimal-configuration.nix
              ../hosts/nixos/${name}/hardware-configuration.nix

              { networking.hostName = name; }
            ];
          }
        );
    in
    {
      nixosConfigurations = {
        # This should mimic what is specified in the respective `nix-config/hosts/[platform]/[hostname]/default.nix`
        # Add entries for each host you will be bootstrapping

        # host = newConfig "name" disk" "swapSize"
        # Swap size is in GiB
        vm = newConfig "vm" "/dev/vda" 0 false false;
        remotevm = newConfig "remotevm" "/dev/vda" 0 false false;
        laptop = newConfig "laptop" "/dev/nvme0n1" 8 false false;
        htpc = newConfig "htpc" "/dev/nvme0n1" 8 false false;

        home = nixpkgs.lib.nixosSystem {
          stdenv.hostPlatform.system = "x86_64-linux";
          specialArgs = minimalSpecialArgs;
          modules = [
            ./minimal-configuration.nix
            ../hosts/nixos/home/hardware-configuration.nix
            { networking.hostName = "home"; }
          ];
        };

        minerva = nixpkgs.lib.nixosSystem {
          stdenv.hostPlatform.system = "x86_64-linux";
          specialArgs = minimalSpecialArgs;
          modules = [
            inputs.disko.nixosModules.disko
            ../hosts/common/disks/minerva.nix
            ./minimal-configuration.nix
            { networking.hostName = "minerva"; }
            ../hosts/nixos/minerva/hardware-configuration.nix
          ];
        };

      };
    };
}
