final: prev: {
  intel-python = final.python313.override {
    packageOverrides = import ./intel-python;
  };
}
