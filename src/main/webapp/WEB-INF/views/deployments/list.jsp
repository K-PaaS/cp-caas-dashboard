<%--
  Created by IntelliJ IDEA.
  User: PHR
  Date: 2018-09-19
  Time: 오후 2:54
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="org.paasta.caas.dashboard.common.Constants" %>
<div class="sortable_wrap">
    <div class="sortable_top">
        <p>Deployments</p>
    </div>
    <div class="view_table_wrap">
        <table class="table_event condition alignL" id="resultDeploymentsTable">
            <colgroup>
                <col style="width:auto;">
                <col style="width:20%;">
                <col style="width:15%;">
                <col style="width:5%;">
                <col style="width:15%;">
                <col style="width:25%;">
            </colgroup>
            <thead>
            <tr id="noResultDeploymentsArea" style="display: none;"><td colspan='6'><p class='service_p'>실행 중인 Deployments가 없습니다.</p></td></tr>
            <tr id="resultDeploymentsHeaderArea" class="headerSortFalse">
                <td>Name<button class="sort-arrow" onclick="procSetSortList('resultDeploymentsTable', this, '0')"><i class="fas fa-caret-down"></i></button></td>
                <td>Namespace</td>
                <td>Labels</td>
                <td>Pods</td>
                <td>Created on<button class="sort-arrow" onclick="procSetSortList('resultDeploymentsTable', this, '4')"><i class="fas fa-caret-down"></i></button></td>
                <td>Images</td>
            </tr>
            </thead>
            <tbody id="deploymentsListArea">
            </tbody>
        </table>
    </div>
</div>


<script type="text/javascript">

    var G_DEPLOYMENTS_LIST_LENGTH;
    var G_DEV_CAHRT_RUNNING_CNT = 0;
    var G_DEV_CHART_FAILED_CNT = 0;
    var G_DEV_CHART_SUCCEEDEDCNT = 0;
    var G_DEV_CHART_PENDDING_CNT = 0;

    // CALLBACK
    var callbackGetDeploymentsList = function (data) {
        if (!procCheckValidData(data)) {
            viewLoading('hide');
            alertMessage();
            return false;
        }

        G_DEPLOYMENTS_LIST_LENGTH = data.items.length;

        var resultArea = $('#deploymentsListArea');
        var resultHeaderArea = $('#resultDeploymentsHeaderArea');
        var noResultArea = $('#noResultDeploymentsArea');
        var resultTable = $('#resultDeploymentsTable');


        $.each(data.items, function (index, itemList) {
            var metadata = itemList.metadata;
            var spec = itemList.spec;
            var status = itemList.status;

            var deployName = metadata.name;
            var namespace = metadata.namespace;
            // 라벨이 없는 경우도 있음.
            var labels = procSetSelector(metadata.labels);
            if (labels == "null") {
                labels = null;
            }

            var creationTimestamp = metadata.creationTimestamp;

            // Set replicas and total Pods are same.
            var totalPods = spec.replicas;
            var runningPods = totalPods - status.unavailableReplicas;
            var containers = itemList.spec.template.spec.containers;
            var imageTags = "";

            for (var i = 0; i < containers.length; i++) {
                imageTags += '<p>' + containers[i].image + '</p>';
            }

            addPodsEvent(itemList, itemList.spec.selector.matchLabels); // 이벤트 추가 TODO :: pod 조회시에도 사용할수 있게 수정

            var statusIconHtml;
            var statusMessageHtml = [];

            if(itemList.type == 'Warning'){ // [Warning]과 [Warning] 외 두 가지 상태로 분류
                statusIconHtml    = "<span class='red2 tableTdToolTipFalse'><i class='fas fa-exclamation-circle'></i> </span>";
                $.each(itemList.message , function (index, eventMessage) {
                    statusMessageHtml += "<p class='red2 custom-content-overflow'>" + eventMessage + "</p>";
                });
            }else{
                statusIconHtml    = "<span class='green2 tableTdToolTipFalse'><i class='fas fa-check-circle'></i> </span>";
            }

            if(itemList.type == "normal") {
                G_DEV_CAHRT_RUNNING_CNT += 1;
            } else if(itemList.type == "Warning") {
                G_DEV_CHART_FAILED_CNT += 1;
            } else {
                G_DEV_CHART_FAILED_CNT += 1;
            }

            var labelObject ="";
            if(!labels) {
                labelObject += "<td>" + nvl(labels, "-") + "</td>";
            } else {
                labelObject += '<td>' + procCreateSpans(labels, "LB") + '</td>'
            }

            resultArea.append('<tr>' +
                                '<td>' +
                                statusIconHtml +
                                "<a href='javascript:void(0);' onclick='procMovePage(\"<%= Constants.URI_WORKLOAD_DEPLOYMENTS %>/" + deployName + "\");'>" + deployName + '</a>' +
                                statusMessageHtml +
                                '</td>' +
                                "<td><a href='javascript:void(0);' onclick='procMovePage(\"<%= Constants.URI_CONTROLLER_NAMESPACE %>/" + namespace + "\");'>" + namespace + "</td>" +
                                labelObject +
                                '<td>' + runningPods +" / " + totalPods + '</td>' +
                                '<td>' + creationTimestamp + '</td>' +
                                "<td>" + imageTags + "</td>" +
                            '</tr>');
        });

        if (G_DEPLOYMENTS_LIST_LENGTH < 1) {
            resultHeaderArea.hide();
            resultArea.hide();
            noResultArea.show();
        } else {
            noResultArea.hide();
            resultHeaderArea.show();
            resultArea.show();
            resultTable.tablesorter();
            resultTable.trigger("update");
            $('.headerSortFalse > td').unbind();
        }

        procSetToolTipForTableTd('resultDeploymentsTable');
        viewLoading('hide');
    };

</script>
