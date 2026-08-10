{
  lib,
  stdenv,
  buildPackages,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
  installShellFiles,
}:
buildGoModule (finalAttrs: {
  pname = "gh-teacher";
  version = "0.1.17";

  src = fetchFromGitHub {
    owner = "foundation50";
    repo = "classroom50";
    tag = "v${finalAttrs.version}";
    # TODO: the actual hash
    hash = "sha256-h/GLgqHN8dGWRCAjBOCqh5nUlj1RSx77obGZ2s1vV6o=";
  };

  # TODO: the actual vendorHash
  vendorHash = "sha256-anYKlaODkRYee8uvaraIbMLwRqdW2xkKo1DEG8FTwtU=";

  # TODO: the actual routine. What i have below is gh-classroom. What's really needed is the following:

  # git clone https://github.com/foundation50/classroom50
  # cd classroom50

  # (cd cli/gh-teacher && go build . && gh extension install .)
  # (cd cli/gh-student && go build . && gh extension install .)

  # After pulling new commits, rebuild — you don't need to reinstall:

  # (cd cli/gh-teacher && go build .)
  # (cd cli/gh-student && go build .)

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) (
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      installShellCompletion --cmd gh-classroom \
        --bash <(${emulator} $out/bin/gh-classroom --bash-completion) \
        --fish <(${emulator} $out/bin/gh-classroom --fish-completion) \
        --zsh <(${emulator} $out/bin/gh-classroom --zsh-completion)
    ''
  );

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/github/gh-teacher";
    description = "Extension for the GitHub CLI, that enhances it for educators using GitHub classroom";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ _0x5a4 ];
    mainProgram = "gh-teacher";
  };
})
