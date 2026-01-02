function showClientImage()
   guiCreateStaticImage( 0.45, -0.01, 0.11, 0.14, "logo1.png", true, nil)
end

addEventHandler( "onClientResourceStart", getResourceRootElement( getThisResource() ), showClientImage )