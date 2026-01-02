txd = engineLoadTXD ( "ganghouse1_lax.txd" )
engineImportTXD ( txd, 3655 )

txd = engineLoadTXD ( "comedhos1_la.txd" )
engineImportTXD ( txd, 3556 )

txd = engineLoadTXD ( "vgnusedcar.txd" )
engineImportTXD ( txd, 7910 )

txd = engineLoadTXD ( "hillhousex4_5.txd" )
engineImportTXD ( txd, 3601 )
engineSetModelLODDistance(3601,3655,7910, 9000090000900009000090000900009000090000)








-- Onde estiver ID, coloque o ID do objeto que você quer substituir.
-- Onde estiver NOME, você coloca o nome dos arquivos na pasta "Skins".
-- No engineSetModelLODDistance você coloca a ID do objeto, logo em seguida a distância que você quer que ele renderize, o máximo permitido pelo MTA é 170.