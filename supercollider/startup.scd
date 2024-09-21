// refs: https://github.com/davidgranstrom/scnvim?tab=readme-ov-file#supported-platforms
if (\SCNvim.asClass.notNil) {
  Server.program = (Platform.resourceDir +/+ "scsynth.exe").quote;
}

