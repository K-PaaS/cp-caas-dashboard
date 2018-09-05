<%@ page import="org.paasta.caas.dashboard.common.Constants" %><%--
  Created by IntelliJ IDEA.
  User: hgcho
  Date: 2018-08-27
  Time: 오후 5:26
  To change this template use File | Settings | File Templates.
--%>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="content">
    <jsp:include page="../common/contents-tab.jsp" flush="true"/>

    <!-- Nodes 시작 -->
    <div class="cluster_content03 row two_line two_view">
        <ul class="maT30">
            <li>
                <div class="sortable_wrap">
                    <div class="sortable_top">
                        <p>Nodes</p>
                        <ul class="colright_btn">
                            <li>
                                <input type="text" id="table-search-01" name="" class="table-search"
                                       placeholder="search"/>
                                <button name="button" class="btn table-search-on" type="button">
                                    <i class="fas fa-search"></i>
                                </button>
                            </li>
                        </ul>
                    </div>
                    <div class="view_table_wrap">
                        <table id="clusters_nodes_table" class="table_event condition alignL">
                            <colgroup>
                                <col style='width:auto;'>
                                <col style='width:5%;'>
                                <col style='width:10%;'>
                                <col style='width:10%;'>
                                <col style='width:12%;'>
                                <col style='width:12%;'>
                                <col style='width:20%;'>
                            </colgroup>
                            <thead>
                            <tr>
                                <td>Name <button data-sort-key="node-name" class="sort-arrow sort"><i class="fas fa-caret-down"></i></button>
                                </td>
                                <td>Ready</td>
                                <td>CPU requests</td>
                                <td>CPU limits</td>
                                <td>Memory requests</td>
                                <td>Memory limits</td>
                                <td>Created on <button data-sort-key="created-on" class="sort-arrow sort"><i class="fas fa-caret-down"></i></button>
                            </tr>
                            </thead>
                            <tbody>
                                <tr><td colspan="7">노드의 정보를 가져올 수 없습니다.</td></tr>
                            </tbody>
                            <!--tfoot>
                                <tr>
                                    <td colspan="7"><button class="btns2 btns2_1 colors4 event_btns">더보기</button></td>
                                </tr>
                            </tfoot-->
                        </table>
                    </div>
                </div>
            </li>
        </ul>
    </div>
    <!-- Nodes 끝 -->
</div>
<script type="text/javascript">
    function getNodes() {
        var reqUrl = "<%= Constants.API_URL %>/nodes"
        procCallAjax(reqUrl, "GET", null, null, callbackGetListNodes);
    }

    // CALLBACK
    var callbackGetListNodes = function(data) {
        if (false == checkValidData(data)) {
            alert("Cannot load nodes data");
            return;
        }

        var contents = [];
        $.each(data.items, function (index, nodeItem) {
            var _metadata = nodeItem.metadata;
            var _status = nodeItem.status;

            var name = _metadata.name;
            var ready = _status.conditions.filter(function(condition) {
                    return condition.type === "Ready";
                })[0].status;
            var limitCPU = _status.capacity.cpu;
            var requestCPU = limitCPU - _status.allocatable.cpu;
            var limitMemory = convertByte(_status.capacity.memory);
            var requestMemory = limitMemory - convertByte(_status.allocatable.memory);
            var creationTimestamp = _metadata.creationTimestamp;

            // TODO
            var nameHtml = '<a href="./nodes/' + name + '/summary"> ' + name + '</a>';
            if (ready == "True")
                nameHtml = '<span class="green2"><i class="fas fa-check-circle"></i></span>' + nameHtml;
            else
                nameHtml = '<span class="red2"><i class="fas fa-exclamation-circle"></i></span>' + nameHtml;

            contents.push('<tr data-node-name="' + name + '" data-created-on="' + creationTimestamp + '">'
                + '<td>' + nameHtml + '</td>'
                + '<td>' + ready + '</td>'
                + '<td>' + requestCPU + '</td>'
                + '<td>' + limitCPU + '</td>'
                + '<td>' + formatCapacity(requestMemory, "Mi") + '</td>'
                + '<td>' + formatCapacity(limitMemory, "Mi") + '</td>'
                + '<td>' + creationTimestamp + '</td></tr>'
            );
        });

        $('#clusters_nodes_table > tbody').html(contents);

        sortTable("clusters_nodes_table", "node-name");
    }

    $(document.body).ready(function(){
        // add sort-arrow click event in pods table
        $(".sort-arrow").on("click", function(event) {
            var tableId = "clusters_nodes_table";
            var sortKey = $(event.currentTarget).data('sort-key');
            var isAscending = $(event.currentTarget).hasClass('sort')? true : false;
            sortTable(tableId, sortKey, isAscending);
        });

        getNodes();
    });
</script>
<!-- Nodes 끝 -->