main:
	java -jar /mnt/c/opt/KickAssembler/KickAss.jar -define PL -o dist/lolopl.prg src/start.asm
debug:
	java -jar /mnt/c/opt/KickAssembler/KickAss.jar -define PL -o dist/lolo.prg src/start.asm -debugdump
	C64Debugger.exe dist/lolo.prg
eng:
	java -jar /mnt/c/opt/KickAssembler/KickAss.jar -define EN -o dist/loloen.prg src/start.asm

