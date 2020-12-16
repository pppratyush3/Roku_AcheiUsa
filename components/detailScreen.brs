sub init()
    m.buttons = m.top.findNode("detailScreenButton")
    m.buttons.buttons = ["Watch now", "Add to playlist"]
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    result = false
    if (key = "right" and press = true) or (key = "left" and press = true)
        if m.buttons.buttonFocused = 0
            m.buttons.buttonFocused = 1
        else
            m.buttons.focusButton = 0
        end if
        result = true
    end if
    return result
end function