var procCallAjax = function(reqUrl, reqMethod, param, preFunc, callback) {
    var reqData = "";
    if (param != null) {
        reqData = param;
    }
    $.ajax({
        url: reqUrl,
        method: reqMethod,
        data: reqData,
        dataType: 'json',
        async: false,
        contentType: "application/json",
        beforeSend: function(){
            ///preFunc
        },
        success: function(data) {
            callback(data);
        },
        error: function(xhr, status, error) {
            //alert("api error message");
        },
        complete : function(data) {
            // SKIP
            console.log("COMPLETE :: data :: ", data);
        }
    });
};

var postProcCallAjax = function (reqUrl, param, callback) {
    console.log("POST REQUEST");

    var reqData = {};

    if (param !== null) {
        reqData = JSON.stringify(param);
    }

    $.ajax({
        url: reqUrl,
        method: "POST",
        data: reqData,
        dataType: 'json',
        contentType: "application/json",
        beforeSend: function (xhr) {
            xhr.setRequestHeader(_csrf_header, _csrf_token);
        },
        success: function (data) {
            if (data) {
                callback(data, param);
            } else {
                var resData = {
                    resultStatus: RESULT_STATUS_SUCCESS
                };
                callback(resData, param);
            }
        },
        error: function (xhr, status, error) {
            console.log("ERROR :: xhr :: ", xhr);
            console.log("ERROR :: status :: ", status);
            console.log("ERROR :: error :: ", error);
        },
        complete: function (data) {
            console.log("COMPLETE :: data :: ", data);
        }
    });
};

// MOVE PAGE
var procMovePage = function (pageUrl) {
    if (pageUrl === null || pageUrl.length < 1) {
        return false;
    }

    if ((!!pageUrl && typeof pageUrl === 'number') && -1 === pageUrl) {
        history.back();
    } else {
        // pageUrl = ("/" === pageUrl) ? "" : pageUrl;
        // location.href = procGetDashboardUrl() + pageUrl;
        location.href = pageUrl;
    }

};


// SET SELECTOR
var procSetSelector = function (requestMapString) {
    if (requestMapString === null || requestMapString.length < 1) {
        return false;
    }

    return JSON.stringify(requestMapString).replace(/["{}]/g, '').replace(/:/g, '=');
};


/**
 * 문자열이 빈 문자열인지 체크하여 빈값("") 또는 기본 문자열을 반환한다.
 * @param str           : 체크할 문자열
 */
function nvl(str, defaultStr){
    if(str == "undefined" || str === undefined || str == "null" || str === null || str == ""){
        if(defaultStr === undefined){
            str = "";
        }else{
            str = defaultStr;
        }
    }
    return str;
}

// SET MENU CURSOR
var procSetMenuCursor = function () {
    var leftMenuList = ["intro", "workloads", "services", "users", "roles"];
    var headerMenuList = ["users", "roles"];
    var leftMenuListLength = leftMenuList.length;
    var calledMenu = leftMenuList[0];

    var currentUrl = location.pathname;
    var splitString = "/";
    var splits = currentUrl.split(splitString);
    var splitsLength = splits.length;

    for (var i = 0; i < leftMenuListLength; i++) {
        for (var j = 0; j < splitsLength; j++) {
            if (leftMenuList[i] === splits[j]) {
                calledMenu = leftMenuList[i];

                if (headerMenuList.includes(splits[j])) {
                    $("#header-menu-" + calledMenu).addClass('cur');
                }
            }
        }
    }

    $("#left-menu-" + calledMenu).addClass('cur');
};


// SET SORT LIST
var procSetSortList = function(resultTableString, buttonObject, key) {
    var resultTable = $('#' + resultTableString);
    var orderDigit = ($(buttonObject).hasClass('sort')) ? 0 : 1; // 0 = ASC, 1 = DESC
    var sorting = [[key, orderDigit]];

    resultTable.tablesorter();
    resultTable.trigger("update");
    resultTable.trigger("sorton", [sorting]);
    $('.headerSortFalse > td').unbind();
};


var procCheckValidData = function (data, checkFunc) {
    var validCheckFunc = procIfDataIsNull(checkFunc, null, function(data) {
        var isNull;
        if (null == data) {
            isNull = true;
        } else if ("" == nvl(data['resultCode'])) {
            isNull = true;
        } else {
            isNull = false;
        }

        if (isNull) {
            // forced 'NOT FOUND' page.
            viewLoading('show');
            procMovePage('/caas');
            data.resultCode = RESULT_STATUS_FAIL;
        }

        return data;
    });

    var ensureData = procIfDataIsNull(data, validCheckFunc, { resultCode: RESULT_STATUS_FAIL });
    if (RESULT_STATUS_FAIL === ensureData.resultCode) {
        return false;
    } else {
        return null != data.resultCode;
    }
};

var procIfDataIsNull = function (data, procCallback, defaultValue) {
    if (null == data) {
        return defaultValue;
    } else {
        if (null == procCallback)
            return data;
        else
            return procCallback(data);
    }
};

// TODO :: REMOVE AFTER CHECK
// var procConvertByte = function(capacity) {
//     var multipleSize;
//     if (capacity.match("Ki").index !== -1) {
//         multipleSize = 1024;
//     } else if (capacity.match("Mi").index !== -1) {
//         multipleSize = 1024 * 1024;
//     } else if (capacity.match("Gi").index !== -1) {
//         multipleSize = 1024 * 1024 * 1024;
//     } else {
//         multipleSize = 1;
//     }
//
//     return capacity.substring(0, capacity.length - 2) * multipleSize;
// };

// var procFormatCapacity = function(capacity, unit) {
//     var unitSize;
//     if (null == unit || "" === unit)
//         unitSize = 1;
//     else {
//         if (unit === "Ki")    unitSize = 1024
//         if (unit === "Mi")    unitSize = Math.pow(1024, 2);
//         if (unit === "Gi")    unitSize = Math.pow(1024, 3);
//     }
//
//     return ((capacity / unitSize).toFixed(2) + ' ' + unit);
// };


// TODO :: REMOVE DUPLICATED
var stringifyJSON = function (obj) {
    return JSON.stringify(obj).replace(/["{}]/g, '').replace(/:/g, '=');
};

// TODO :: REMOVE AFTER CHECK
//TODO 이중에 골라서.
//https://www.jqueryscript.net/demo/Fullscreen-Loading-Modal-Indicator-Plugin-For-jQuery-loadingModal/

// $('body').loadingModal({text: 'Showing loader animations...'});
//
// var delay = function(ms){ return new Promise(function(r) { setTimeout(r, ms) }) };
// var time = 2000;
//
// delay(time)
//     .then(function() { $('body').loadingModal('animation', 'rotatingPlane').loadingModal('backgroundColor', 'red'); return delay(time);})
//     .then(function() { $('body').loadingModal('animation', 'wave'); return delay(time);})
//     .then(function() { $('body').loadingModal('animation', 'wanderingCubes').loadingModal('backgroundColor', 'green'); return delay(time);})
//     .then(function() { $('body').loadingModal('animation', 'spinner'); return delay(time);})
//     .then(function() { $('body').loadingModal('animation', 'chasingDots').loadingModal('backgroundColor', 'blue'); return delay(time);})
//     .then(function() { $('body').loadingModal('animation', 'threeBounce'); return delay(time);})
//     .then(function() { $('body').loadingModal('animation', 'circle').loadingModal('backgroundColor', 'black'); return delay(time);})
//     .then(function() { $('body').loadingModal('animation', 'cubeGrid'); return delay(time);})
//     .then(function() { $('body').loadingModal('animation', 'fadingCircle').loadingModal('backgroundColor', 'gray'); return delay(time);})
//     .then(function() { $('body').loadingModal('animation', 'foldingCube'); return delay(time); } )
//     .then(function() { $('body').loadingModal('color', 'black').loadingModal('text', 'Done :-)').loadingModal('backgroundColor', 'yellow');  return delay(time); } )
//     .then(function() { $('body').loadingModal('hide'); return delay(time); } )
//     .then(function() { $('body').loadingModal('destroy') ;} );


// TODO :: CHECK
var viewLoading = function(type) {
    var dashboardWrap = $("#dashboardWrap");
    var loader = $("#loadingSpinner");

    if (type === 'show') {
        loader.show().gSpinner();
    } else {
        dashboardWrap.show();
        setTimeout(function(){
            loader.gSpinner("hide").hide();
        }, 1000);
    }
    // TODO :: REMOVE AFTER CHECK
    // var dashboardWrap = $("#dashboardWrap");
    //
    // if (type === 'show') {
    //     console.log(":: Show Loading..");
    //     var bodyObj = $('body');
    //     bodyObj.loadingModal();
    //     bodyObj.loadingModal('animation', 'chasingDots').loadingModal('color', 'black').loadingModal('backgroundColor', 'white');
    //     dashboardWrap.show();
    // } else if (type === 'hide') {
    //     console.log(":: Hide Loading..");
    //     setTimeout(function(){
    //         $('body').loadingModal('destroy') ;
    //     }, 1000);
    //
    // }
};


var alertMessage = function(value, result) {
    // TODO :: SEPARATE PROPERTY
    var messageValue = '시스템 에러가 발생했습니다.';

    if (nvl(value) !== '') {
        messageValue = value;
    }

    $(".alertLayer .in").html(messageValue);
    if (result) {
        $(".alertLayer").css('border-left', '4px solid #3d10ef');
    } else {
        $(".alertLayer").css('border-left', '4px solid #cb3d4a');
    }
    $(".alertLayer").addClass("moveAlert");

    setTimeout(function(){ $(".alertLayer").removeClass("moveAlert"); }, 3000);

    // setInterval(function(){
    //   $(".alertLayer").removeClass("moveAlert");
    // }, 3000);
};


// TODO :: REMOVE AFTER CHECK
var isPodEventOverwrite = true;

// SET EVENT STATUS FOR PODS
var procSetEventStatusForPods = function(podNameList) {
    viewLoading('show');

    var listLength = podNameList.length;
    var reqUrl;

    for (var i = 0; i < listLength; i++) {
        reqUrl = URI_API_EVENTS_LIST.replace("{namespace:.+}", NAME_SPACE).replace("{resourceName:.+}", podNameList[i]);
        procCallAjax(reqUrl, "GET", null, null, callbackSetEventStatusForPods);
    }
};


// CALLBACK
var callbackSetEventStatusForPods = function(data) {
    if (!procCheckValidData(data)) {
        viewLoading('hide');
        alertMessage(nvl(data.resultMessage, "Event를 가져올 수 없습니다."), false);
        return false;
    }

    var itemType;
    var podName = data.resourceName;
    var items = data.items;
    var listLength = items.length;
    var itemStatusIconHtml = "<span class='green2'><i class='fas fa-check-circle'></i></span>";
    var itemNameLinkHtml = "<a href='javascript:void(0);' onclick='procMovePage(\"" + URI_WORKLOADS_PODS + "/" + podName + "\");'>" + podName + "</a>" ;
    var itemMessageHtml;
    var itemMessageList = [];

    var warningCount = 0;
    for (var i = 0; i < listLength; i++) {
        if (items[i].type === 'Warning') {
            itemStatusIconHtml = "<span class='failed2'><i class='fas fas fa-exclamation-circle'></i></span> ";
            itemMessageList.push(
                $('<p class="failed2 custom-content-overflow" data-toggle="tooltip">' + items[i].message + '</p>').attr('title', items[i].message).wrapAll("<div/>").parent().html()
            );
            warningCount++;
        }
    }

    if (warningCount > 0) {
        itemMessageHtml = itemMessageList.join("");
        $('#' + podName).html(itemStatusIconHtml + ' ' + itemNameLinkHtml + itemMessageHtml);
    }

    viewLoading('hide');
};


/**
 * 해당 리소스에 이벤트 데이터를 추가한다.
 * @param targetObject   : 해당 리소스의 리스트 JSON Object
 * @param selector       : 연관된 POD를 조회하기 위한 SELECTOR
 * @description
 *    해당 리소스(replicaSet, deployment)에 연관된 POD명을 조회하여,
 *    해당 POD의 이벤트를 조회후,
 *    해당 리소스의 리스트에 이벤트 데이터를 추가 합니다.
 *
 *    targetObject : 이벤트 데이터를 추가할 대상 JSON Object 입니다.(replicaSet, deployment 리스트 데이터)
 *    selector     : replace 처리되지 않은 json Data 입니다.
 *
 *    ex) addPodsEvent(itemList, itemList.spec.selector.matchLabels); // event Data added to 'itemList'
 *
 * @author CISS
 * @since 2018.09.12
 */
var addPodsEvent = function(targetObject, selector) {

    selector = procSetSelector(selector);

    // 기존 리스트 데이터에 event.type, event.message 추가
    var eventType = 'normal';
    var eventMessage = [];

    var reqPodsUrl = URI_API_PODS_RESOURCES
        .replace("{namespace:.+}", NAME_SPACE)
        .replace("{selector:.+}", selector);
    procCallAjax(reqPodsUrl, "GET", null, null, function(podsData){
        $.each(podsData.items, function (index, itemList) {
            var podsName = itemList.metadata.name;
            //console.log("podsName::::::"+podsName);

            var reqEventsUrl = URI_API_EVENTS_LIST
                .replace("{namespace:.+}", NAME_SPACE)
                .replace("{resourceName:.+}", podsName);
            procCallAjax(reqEventsUrl, "GET", null, null, function(eventData){
                $.each(eventData.items, function (index, eData) {

                    var eType = eData.type;
                    if(eType == 'Warning'){
                        eventType = eType;
                    }
                    eventMessage.push(eData.message);
                });

            });

            //console.log('eventType:::'+eventType);
            //console.log('eventMessage:::'+eventMessage);
        }); // Event API call end
    }); //Pods API call end

    targetObject.type = eventType;
    targetObject.message = eventMessage;
    //console.log("Print:::"+JSON.stringify(targetObject));

}


// SET TOOL TIP FOR TABLE TD
var procSetToolTipForTableTd = function (tableObjectString) {
    if (nvl(tableObjectString) === '') {
        return false;
    }

    var tableObject = $('#' + tableObjectString + ' tr');

    tableObject.each(function () {
        var tdTags = $(this).find('td');
        var pTags,
            aTags,
            spanTags;

        if (tdTags != null) {
            pTags = $(this).find('p');
            aTags = $(this).find('a');
            spanTags = $(this).find('span');

            pTags.each(function () {
                if (nvl(pTags) !== '') {
                    procSetToolTipAttributes($(this));
                }
            });

            aTags.each(function () {
                if (nvl(aTags) !== '') {
                    procSetToolTipAttributes($(this));
                }
            });

            spanTags.each(function () {
                if (nvl(spanTags) !== '') {
                    procSetToolTipAttributes($(this));
                }
            });
        }
    });
};


// PROC SET TOOL TIP ATTRIBUTES
var procSetToolTipAttributes = function (tagObject) {
    var tagObjectHtml = tagObject.html();
    if (!tagObject.hasClass('tableTdToolTipFalse') && tagObjectHtml !== '' && tagObjectHtml !== '-') {
        tagObject.addClass('custom-content-overflow');
        tagObject.attr('data-toggle', 'tooltip').attr('title', tagObjectHtml).attr('style', 'margin: 0;');
    }
};


var procCreateSpans = function (data, type) {
    if( !data || data == "null") {
        return "-";
    }
    var datas = data.replace(/=/g, ':').split(',');
    var spanTemplate = "";

    if (type === "LB") { // Line Break
        $.each(datas, function (index, data) {
            if (index != 0) {
                spanTemplate += '<br>';
            }
            spanTemplate += '<span class="bg_gray">' + data + '</span>';
        });
    } else {
        $.each(datas, function (index, data) {
            spanTemplate += '<span class="bg_gray">' + data + '</span> ';
        });
    }
    return spanTemplate;
}