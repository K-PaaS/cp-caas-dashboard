<%--
  Access Info main
  @author REX
  @version 1.0
  @since 2018.08.23
--%>
<%@ page contentType="text/html;charset=UTF-8" %>

<div class="content">
    <div class="cluster_tabs clearfix"></div>
    <div class="cluster_content01 row two_line two_view">
        <div class="account_table access">
            <table>
                <colgroup>
                    <col style="width:100%;">
                </colgroup>
                <tbody>
                <tr>
                    <td>
                        <label for="access-user-name">User name *</label>
                        <input id="access-user-name" type="text" value="hong" placeholder="User name">
                    </td>
                </tr>
                <tr>
                    <td>
                        <label for="access-user-email">Email *</label>
                        <input id="access-user-email" type="email" value="hong.test.com" placeholder="Email">
                    </td>
                </tr>
                <tr>
                    <td>
                        <label for="access-user-token">Token</label>
                        <input id="access-user-token" type="password" placeholder="Token">
                        <button class="btn-copy" data-clipboard-action="cut" data-clipboard-target="#out_a">
                            <i class="fas fa-clipboard"></i>
                        </button>
                        <p>
                            Kubectl에서 생성한 토큰으로 액세스 사용할 수 있습니다.<br/>
                            토큰을 응용 프로그램과 공유 할 때 주의 하십시오. 공용 코드 저장소에 사용자 토큰을 게시하지 마십시오.
                        </p>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label for="access-user-role">Role</label>
                        <input id="access-user-role" type="text" value="administrator" disabled>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>