sub init()

    m.rowlist = m.top.findNode("exampleRowList")
    m.video = m.top.findNode("Video")
    m.video.observeField("state", "onVideoStateChanged")

    m.taskNode = CreateObject("roSGNode", "taskNode")
    m.taskNode.observefield("content", "rowListContentChanged")
    m.taskNode.observefield("mediaIndex", "indexloaded")
    m.taskNode.control = "RUN"
    m.taskNode.setFocus(true)

    m.poster = m.top.findNode("topBackgroundPoster")
    m.detailPoster = m.top.findNode("detailBackgroundPoster")
    m.detailScreen = m.top.findNode("detailScreen")
    m.rect = m.top.findNode("rect")

    m.mainTitle = m.top.findNode("mainTitle")
    m.date = m.top.findNode("date")
    m.description = m.top.findNode("description")
    m.quality = m.top.findNode("quality")

    m.detailMainTitle = m.top.findNode("detailMainTitle")
    m.detailDuration = m.top.findNode("duration")
    m.detailDescription = m.top.findNode("detailDescription")

    m.rowlist.observefield("rowItemFocused", "onRowItemFocused")
    m.rowlist.observeField("rowItemSelected", "onRowItemSelected")

    m.global.addField("videoLink", "string", false)
    m.rowlist.setFocus(true)
end sub

sub rowListContentChanged(msg as object)
    if type(msg) = "roSGNodeEvent" and msg.getField() = "content"
        m.rowlist.content = msg.getData()
    end if
end sub

sub indexloaded(msg as object)
    if type(msg) = "roSGNodeEvent" and msg.getField() = "mediaIndex"
        m.mediaIndex = msg.getData()
    end if
    handleDeepLink(m.global.deeplink)
end sub

function handleDeepLink(deeplink as object)
    if validateDeepLink(deeplink)
        playVideo(m.mediaIndex[deeplink.id].url)
    else
        print "deeplink not validated"
    end if
end function


function validateDeepLink(deeplink as object) as boolean
    mediatypes = { movie: "movie", episode: "episode", season: "season", series: "series" }
    if deeplink <> invalid

        if deeplink.type <> invalid then
            if mediatypes[deeplink.type] <> invalid
                if m.mediaIndex[deeplink.id] <> invalid
                    if m.mediaIndex[deeplink.id].url <> invalid
                        return true
                    else
                        print "invalid deep link url"
                    end if
                else
                    print "bad deep link contentId"
                end if
            else
                print "unknown media type"
            end if
        else
            print "deeplink.type string is invalid"
        end if
    end if
    return false
end function


sub playVideo(url = invalid)
    m.videocontent = createObject("RoSGNode", "ContentNode")
    if type(url) = "roSGNodeEvent" ' passed from observe callback'
        m.videoContent.url = m.rowList.content.getChild(m.RowList.rowItemFocused[0]).getChild(m.RowList.rowItemFocused[1]).URL
    else
        m.videoContent.url = url
    end if
    m.video.content = m.videoContent
    m.video.visible = "true"
    m.video.control = "play"
    m.video.setFocus(true)
end sub


function onVideoStateChanged(msg as object)
    if type(msg) = "roSGNodeEvent" and msg.getField() = "state"
        if msg.getData() = "finished"
            m.video.visible = "false"
            m.video.control = "stop"
            m.rowlist.setFocus(true)
        end if
    end if
end function

sub onRowItemFocused(msg as object)
    row = msg.getData()[0]
    col = msg.getData()[1]
    m.poster.uri = m.global.obj.categories[row].video[col].thumbnail
    m.mainTitle.text = m.global.obj.categories[row].video[col].title
    m.date.text = Left(m.global.obj.categories[row].video[col].date, 10)
    m.description.text = m.global.obj.categories[row].video[col].shortDescription
    m.quality.text = m.global.obj.categories[row].video[col].quality
end sub

sub onRowItemSelected(msg as object)
    row = msg.getData()[0]
    col = msg.getData()[1]

    m.detailPoster.uri = m.poster.uri

    m.detailMainTitle.text = m.global.obj.categories[row].video[col].title
    m.detailDuration.text = m.global.obj.categories[row].video[col].duration
    m.detailDescription.text = m.global.obj.categories[row].video[col].shortDescription

    m.detailScreen.visible = true

    m.top.videoTitle = m.global.obj.categories[row].video[col].title
    m.global.videoLink = m.global.obj.categories[row].video[col].url

    m.detailScreen.setFocus(true)
    m.rect.visible = false
end sub

function OnkeyEvent(key as string, press as boolean) as boolean
    result = false
    if (key = "back") and press = true
        m.rect.visible = true
        m.detailScreen.visible = false
        m.video.visible = "false"
        m.video.control = "stop"
        result = true
        m.rowlist.setFocus(true)
    end if
    return result
end function