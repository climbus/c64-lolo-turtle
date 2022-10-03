main:
	java -jar /mnt/c/opt/KickAssembler/KickAss.jar -o dist/lolo.prg src/start.asm
debug:
	java -jar /mnt/c/opt/KickAssembler/KickAss.jar -o dist/lolo.prg src/start.asm -debugdump
	C64Debugger.exe dist/lolo.prg
