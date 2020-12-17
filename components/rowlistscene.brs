sub init()

    rowlist = m.top.findNode("exampleRowList")
    rowlist.content = getContent()

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

    rowList.observefield("rowItemFocused", "onRowItemFocused")
    rowList.observeField("rowItemSelected", "onRowItemSelected")
    m.top.setFocus(true)
end sub

sub onRowItemFocused(msg as object)
    row = msg.getData()[0]
    col = msg.getData()[1]
    m.poster.uri = m.obj.tvSpecials[row].thumbnail
    m.mainTitle.text = m.obj.tvSpecials[row].title
    m.date.text = m.obj.tvSpecials[row].content.dateAdded
    m.description.text = m.obj.tvSpecials[row].shortDescription
    m.quality.text = m.obj.tvSpecials[row].content.videos[col].quality
end sub

sub onRowItemSelected(msg as object)
    row = msg.getData()[0]
    col = msg.getData()[1]


    m.detailPoster.uri = m.poster.uri

    m.detailMainTitle.text = m.obj.tvSpecials[row].title
    m.detailDuration.text = m.obj.tvSpecials[row].content.duration
    m.detailDescription.text = m.obj.tvSpecials[row].shortDescription

    m.detailScreen.visible = true

    m.top.videoTitle = m.obj.tvSpecials[row].title
    m.global.videoLink = m.obj.tvSpecials[row].content.videos[col].url
    print "video link"
    print m.global.videoLink
    print m.obj.tvSpecials[row].content.videos[col].url
    print "video title"
    print m.top.videoTitle
    print m.obj.tvSpecials[row].title

    m.detailScreen.setFocus(true)
    m.rect.visible = false
end sub

function getContent()
    filePath = "pkg:/components/Data/sample.json"
    text = ReadAsciiFile(filePath)
    m.obj = ParseJSON(text)

    rootContentNode = CreateObject("roSGNode", "RowListContent")

    for each item in m.obj.tvSpecials
        childNode = rootContentNode.CreateChild("ContentNode")
        childNode.title = item.title
        for each video in item.content.videos
            gChild = childNode.CreateChild("ContentNode")
            'gChild.posterUrl = video.Thumbnail
            gChild.title = video.Title
            gChild.HDPosterUrl = item.thumbnail
        end for
    end for

    return rootContentNode
end function

function OnkeyEvent(key as string, press as boolean) as boolean
    print "back to main scene"
    result = false
    if (key = "back") and press = true
        m.rect.visible = true
        m.detailScreen.visible = false
        result = true
    end if
    return result
end function