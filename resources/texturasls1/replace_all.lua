addEventHandler("onClientResourceStart", resourceRoot,
    function()
        local txdStormdrain = engineLoadTXD("stormdrain.txd")
        if txdStormdrain then
            for _, id in ipairs({17500, 17506, 17507, 17567, 17568, 17686, 17688}) do
                engineImportTXD(txdStormdrain, id)
            end
        end

        local txdStormLas2 = engineLoadTXD("stormdrain_las2.txd")
        if txdStormLas2 then
            for _, id in ipairs({5105, 5355}) do
                engineImportTXD(txdStormLas2, id)
            end
        end

        local txdStorm2Las2 = engineLoadTXD("stormdrain2_las2.txd")
        if txdStorm2Las2 then
            for _, id in ipairs({5270, 5274}) do
                engineImportTXD(txdStorm2Las2, id)
            end
        end

        local txdStormdra1 = engineLoadTXD("stormdra1_lae.txd")
        if txdStormdra1 then
            for _, id in ipairs({5652, 5404, 5419, 5420}) do
                engineImportTXD(txdStormdra1, id)
            end
        else
            if txdStormdrain then
                for _, id in ipairs({5652, 5404, 5419, 5420}) do
                    engineImportTXD(txdStormdrain, id)
                end
            end
        end

        local txdLanriver = engineLoadTXD("lanriver.txd")
        if txdLanriver then
            for _, id in ipairs({3989, 4029, 4030, 3978, 4198, 4203}) do
                engineImportTXD(txdLanriver, id)
            end
        end
    end
)
