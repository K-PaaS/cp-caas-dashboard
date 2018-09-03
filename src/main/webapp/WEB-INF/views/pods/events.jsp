<%@ page import="org.paasta.caas.dashboard.common.Constants" %><%--
  Deployments main
  @author Hyungu Cho
  @version 1.0
  @since 2018.08.14
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<div class="content">
    <jsp:include page="common-pods.jsp"/>

    <%-- NODES HEADER INCLUDE --%>
    <jsp:include page="../common/contents-tab.jsp" flush="true"/>

    <!-- Events 시작-->
    <div class="cluster_content02 row two_line two_view harf_view">
        <ul class="maT30">
            <li class="cluster_first_box">
                <div class="sortable_wrap">
                    <div class="sortable_top">
                        <p>Events</p>
                    </div>
                    <div class="view_table_wrap">
                        <table class="table_event condition alignL">
                            <colgroup>
                                <col style=".">
                                <col style=".">
                                <col style=".">
                                <col style=".">
                                <col style=".">
                                <col style=".">
                            </colgroup>
                            <thead>
                            <tr>
                                <td>Message</td>
                                <td>Source</td>
                                <td>Sub-object</td>
                                <td>Count</td>
                                <td>First seen</td>
                                <td>Last seen</td>
                            </tr>
                            </thead>
                            <tbody>
                            <tr>
                                <td>Created pod: aa-57cff4f9df-xcstf
                                </td>
                                <td>replicaset-controller
                                </td>
                                <td>-
                                </td>
                                <td>1
                                </td>
                                <td>2018-07-08 18:31:01
                                </td>
                                <td>2018-07-09 18:31:01
                                </td>
                            </tr>
                            <tr>
                                <td>Created pod: aa-57cff4f9df-xcstf
                                </td>
                                <td>replicaset-controller
                                </td>
                                <td>-
                                </td>
                                <td>1
                                </td>
                                <td>2018-07-08 18:31:01
                                </td>
                                <td>2018-07-09 18:31:01
                                </td>
                            </tr>
                            <tr>
                                <td>Created pod: aa-57cff4f9df-xcstf
                                </td>
                                <td>replicaset-controller
                                </td>
                                <td>-
                                </td>
                                <td>1
                                </td>
                                <td>2018-07-08 18:31:01
                                </td>
                                <td>2018-07-09 18:31:01
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </li>
        </ul>
    </div>
    <!-- Events 끝 -->
</div>