<%--
  Pod main
  @author Hyungu Cho
  @version 1.0
  @since 2018.08.14
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<div style="padding: 10px;">
    POD 대시보드 :: PODS DASHBOARD
    <div style="padding: 10px;">
        <div style="padding: 5px;">
            <div style="padding: 5px;">
                <span>Namespace: </span>
                <input type="text" id="namespace">
                <span>&nbsp;&nbsp;&nbsp;//&nbsp;&nbsp;&nbsp;</span>
                <span>Pod name: </span>
                <input type="text" id="pod">
            </div>
            <button type="button" id="btnSearch"> [ 조회(None / NS / NS+Dep) ] </button>
            <button type="button" id="btnReset"> [ 목록 초기화 ] </button>
        </div>
    </div>
    <h1>RESULT</h1>
    <div id="resultArea" style="width: 98%; height: auto; min-height: 100px; padding: 10px; margin: 1%; border: dotted deepskyblue 4px;">
    </div>
</div>
<script type="text/javascript">
  var getAllPods = function(){
    // get all pod list
    procCallAjax("/workload/pods/getList.do", "GET", null, null, callbackGetList);
  }

  var getPods = function() {
    // get pod list in namespace or pod detail
    // ex) get pod list ->  /workload/pods/default/getList.do
    // ex) get pod detail -> /workload/pods/default/getPod.do?podName=nginx-deployment-67594d6bf6-h5fh7
    var namespaceVal = $( "#namespace" ).val();
    var podVal = $( "#pod" ).val();
    if (false == ( namespaceVal != null && namespaceVal.replace(/\s/g, '').length > 0 ))
      namespaceVal = undefined;
    if (false == ( podVal != null && podVal.replace(/\s/g, '').length > 0 ))
      podVal = undefined;

    var reqUrl = "/workload/pods";

    if ( namespaceVal != null ) {
      reqUrl += "/" + namespaceVal;
      if ( podVal != null ) {
        reqUrl += "/getPod.do";
        var param = {
          name: podVal
        }
        procCallAjax( reqUrl, "GET", param, null, callbackGetPod );
      } else {
        reqUrl += "/getList.do"
        procCallAjax( reqUrl, "GET", null, null, callbackGetList );
      }
    } else {
      procCallAjax( reqUrl + "/getList.do", "GET", null, null, callbackGetList );
    }
  }

  var stringifyJSON = function(obj) {
    return JSON.stringify(obj).replace(/["{}]/g, '').replace(/:/g, '=');
  }

  // CALLBACK
  var callbackGetList = function(data) {
    if (RESULT_STATUS_FAIL === data.resultCode) {
      $('#resultArea').html(
        "ResultStatus :: " + data.resultCode + " <br><br>"
        + "ResultMessage :: " + data.resultMessage + " <br><br>");
      return false;
    }

    console.log("CONSOLE DEBUG PRINT :: " + data);

    var htmlString = [];
    htmlString.push("PODS LIST :: <br><br>");
    htmlString.push( "ResultCode :: " + data.resultCode + " || "
      + "Message :: " + data.resultMessage + " <br><br>");

    //
    $.each(data.items, function(index, itemList) {
      // get data
      var _metadata = itemList.metadata;
      var _spec = itemList.spec;
      var _status = itemList.status;

      // required : name, namespace, node, status, restart(count), created on, pod error message(when it exists)
      var podName = _metadata.name;
      var namespace = _metadata.namespace;
      var nodeName = _spec.nodeName;
      var podStatus = _status.phase;
      var restartCount = _status.containerStatuses.reduce(function(a, b) {
        return { restartCount: a.restartCount + b.restartCount };
      }, { restartCount: 0 }).restartCount;
      //var restartCount = _status.containerStatuses
      //  .map(function(datum) { return datum.restartCount; })
      //  .reduce(function(a, b) { return a + b; }, 0 );

      var creationTimestamp = _metadata.creationTimestamp;
      // error message will be filtering from namespace's event. a variable value is like...
      //var errorMessage = _status.error.message;
      var errorMessage = "";

      // htmlString push
      htmlString.push("Name :: " + podName + " || "
        + "Namespace :: " + namespace + " || "
        + "Node :: " + nodeName + " || "
        + "Status :: " + podStatus + " || "
        + "Restart Count :: " + restartCount + " || "
        + "Created At :: " + creationTimestamp + " || "
        + "Error message :: " + errorMessage
        + "<br><br>" );
    });

    //var $resultArea = $('#resultArea');
    $('#resultArea').html(htmlString);
  };

  var callbackGetPod = function(data) {
    if (RESULT_STATUS_FAIL === data.resultCode) {
      $('#resultArea').html(
        "ResultStatus :: " + data.resultCode + " <br><br>"
        + "ResultMessage :: " + data.resultMessage + " <br><br>");
      return false;
    }

    console.log("CONSOLE DEBUG PRINT :: " + data);

    // get data
    var _metadata = itemList.metadata;
    var _spec = itemList.spec;
    var _status = itemList.status;

    // required : name, namespace, labels, created time, status, QoS Class, Node, IP (Internal, External), Conditions, Controllers, Volumes
    var podName = _metadata.name;
    var namespace = _metadata.namespace;
    var label;
    var creationTimestamp;
    var status;
    var qosClass;
    var nodeName;
    var internalIP;
    var externalIP;
    var conditions;
    var controllers;
    var volumes;


    var nodeName = _spec.nodeName;
    var podStatus = _status.phase;
    var restartCount = _status.containerStatuses.reduce(function(a, b) {
      return { restartCount: a.restartCount + b.restartCount };
    }, { restartCount: 0 }).restartCount;
    //var restartCount = _status.containerStatuses
    //  .map(function(datum) { return datum.restartCount; })
    //  .reduce(function(a, b) { return a + b; }, 0 );

    var creationTimestamp = _metadata.creationTimestamp;
    // error message will be filtering from namespace's event. a variable value is like...
    //var errorMessage = _status.error.message;
    var errorMessage = "";

    // htmlString push
    htmlString.push("Name :: " + podName + " <br><br>"
      + "Namespace :: " + namespace + " <br><br>"
      + "Node :: " + nodeName + " <br><br>"
      + "Status :: " + podStatus + " <br><br>"
      + "Restart Count :: " + restartCount + " <br><br>"
      + "Created At :: " + creationTimestamp + " <br><br>"
      + "Error message :: " + errorMessage + "<br><br>" );

    //var $resultArea = $('#resultArea');
    $('#resultArea').html(htmlString);
  }


  // BIND
  $("#btnReset").on("click", function() {
    $('#resultArea').html("");
  });

  // ALREADY READY STATE
  $(document).ready(function(){
    $("#btnAllSearch").on("click", function (e) {
      getAllPods();
    });

    $("#btnSearch").on("click", function (e) {
      getPods();
    });
  });

  // ON LOAD
  $(document.body).ready(function () {
      getAllPods();
  });

</script>
