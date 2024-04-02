export def "to nix" [] {
    let json = $in | to json
    let expr = $"builtins.fromJSON ''($json)''"

    nix eval --expr $expr | alejandra --quiet
}