sub init()
    m.buttons = m.top.findNode("detailScreenButton")
    print "button==>"
    m.buttons.buttons = ["Watch now", "Add to playlist"]
    print m.buttons.buttons
    print m.buttons
    print "details"
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    print "key=>2"
    print key
    result = false
    if (key = "right" and press = true) or (key = "left" and press = true)
        print "key=>"
        print key
        print press
        if m.buttons.buttonFocused = 0
            m.buttons.buttonFocused = 1
        else
            m.buttons.focusButton = 0
        end if
        result = true
    end if
    return result
end function