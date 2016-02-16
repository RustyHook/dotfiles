var tineye = tineye || {};

tineye.SERVER = 'www.tineye.com';
tineye.CHROME_VERSION = '1.1.4';

tineye.sortOrder = function() {
    // Check which sort order the user wants
    sort_order = "";
    switch(localStorage.sort_order) {
        case "best_match":
            sort_order = "&sort=score&order=desc";
            break;
        case "most_changed":
            sort_order = "&sort=score&order=asc";
            break;
        case "biggest_image":
            sort_order = "&sort=size&order=desc";
            break;
        case "newest":
            sort_order = "&sort=crawl_date&order=desc";
            break;
        case "oldest":
            sort_order = "&sort=crawl_date&order=asc";
            break;
        default:
            sort_order = "";
    }
    return sort_order;
};

tineye.openUrl = function(url) {
    // Open new tabs next to current one
    chrome.tabs.query({ currentWindow: true, active: true }, function (tabs) {

        // Get new tab index
        var new_tab_index = tabs[0].index + 1;

        // Check where the user wants the url to be open
        switch(localStorage.tab_visibility) {
            case "background":
                chrome.tabs.create({url: url, active: false, index: new_tab_index});
                break;
            case "foreground":
                chrome.tabs.create({url: url, active: true, index: new_tab_index});
                break;
            case "current":
                chrome.tabs.update(tabs[0].id, {url: url});
                break;
            default:
                chrome.tabs.create({url: url, active: false, index: new_tab_index});                   
        }

    });
};

tineye.imageSearch = function(info, tab) {
    // Send the selected image to TinEye
    sort_order = tineye.sortOrder();
    url = encodeURIComponent(info.srcUrl);
    tineye.openUrl("http://" + tineye.SERVER + "/search/?pluginver=chrome-" +
        tineye.CHROME_VERSION +  sort_order + "&url=" + url);
};

tineye.pageSearch = function(info, tab) {
    // Send the selected page to TinEye
    sort_order = tineye.sortOrder();
    url = encodeURIComponent(info.pageUrl);
    tineye.openUrl("http://" + tineye.SERVER + "/search/?pluginver=chrome-" +
        tineye.CHROME_VERSION + sort_order + "&url=" + url);
};

// Create two context menu items for image, and page clicks
chrome.contextMenus.create({
    "title": "Search Image on TinEye",
    "contexts": ["image"],
    "onclick": tineye.imageSearch});

chrome.contextMenus.create({
    "title": "Search Page on TinEye", 
    "contexts": ["page"],
    "onclick": tineye.pageSearch});
