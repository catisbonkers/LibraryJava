<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.demo1.model.User" %>
<%@ page import="com.example.demo1.service.UserService" %>
<%@ page import="java.util.List" %>
<html data-theme="light">
<head>
    <title>User Management | LibraSync</title>
    <%@ include file="/WEB-INF/jspf/head.jspf" %>
</head>
<body class="bg-base-200">
<%
    User admin = (User) session.getAttribute("user");
    if (admin == null || !admin.isAdmin()) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
    List<User> users = UserService.getAllUsers();
%>
<div class="drawer lg:drawer-open">
    <input id="drawer" type="checkbox" class="drawer-toggle" />
    <div class="drawer-content flex flex-col min-h-screen">
        <div class="navbar bg-base-100/50 backdrop-blur-xl sticky top-0 z-30 shadow-sm border-b border-white/20">
            <label for="drawer" class="btn btn-square btn-ghost lg:hidden">
                <i class="lucide-menu"></i>
            </label>
            <div class="flex-1 px-4">
                <div class="text-xl font-black bg-clip-text text-transparent bg-gradient-to-r from-primary to-secondary tracking-tight">
                    USER MANAGEMENT
                </div>
            </div>
            <div class="flex-none gap-2 px-4">
                <div class="badge badge-outline badge-lg font-mono opacity-50"><%= users.size() %> USERS</div>
            </div>
        </div>

        <div class="p-4 lg:p-8 flex-1">
            <div class="max-w-6xl mx-auto">
                <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4 mb-8">
                    <div>
                        <h1 class="text-4xl font-black tracking-tight mb-2">Member Directory</h1>
                        <p class="text-base-content/60">Manage permissions, status, and borrowing limits for all members.</p>
                    </div>
                </div>
                
                <div class="glass-panel rounded-3xl overflow-hidden border border-white/40 shadow-2xl">
                    <div class="overflow-x-auto">
                        <table class="table table-lg w-full">
                            <thead>
                                <tr class="bg-base-200/50">
                                    <th class="bg-transparent">User</th>
                                    <th class="bg-transparent">Security Status</th>
                                    <th class="bg-transparent">Registration</th>
                                    <th class="bg-transparent">Quota</th>
                                    <th class="bg-transparent text-right">Operations</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (User u : users) { %>
                                <tr class="hover:bg-primary/5 transition-colors group">
                                    <td>
                                        <div class="flex items-center gap-4">
                                            <div class="avatar placeholder">
                                                <div class="bg-neutral text-neutral-content rounded-xl w-12 shadow-lg group-hover:scale-110 transition-transform flex items-center justify-center">
                                                    <span class="text-xl font-bold"><%= u.getUsername().substring(0,1).toUpperCase() %></span>
                                                </div>
                                            </div>
                                            <div>
                                                <div class="font-black text-lg"><%= u.getUsername() %></div>
                                                <div class="badge badge-sm badge-ghost opacity-50 font-bold uppercase tracking-widest"><%= u.getRole() %></div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <% if ("BANNED".equals(u.getStatus())) { %>
                                            <div class="flex flex-col">
                                                <span class="badge badge-error gap-2 font-bold px-3 py-3">
                                                    <i class="lucide-ban size-3"></i> BANNED
                                                </span>
                                                <span class="text-xs opacity-60 mt-1 pl-1 italic">"<%= u.getStatusReason() %>"</span>
                                            </div>
                                        <% } else if ("VERIFIED".equals(u.getStatus())) { %>
                                            <span class="badge badge-success gap-2 font-bold px-3 py-3 text-white">
                                                <i class="lucide-shield-check size-3"></i> VERIFIED
                                            </span>
                                        <% } else { %>
                                            <div class="flex flex-col">
                                                <span class="badge badge-warning gap-2 font-bold px-3 py-3">
                                                    <i class="lucide-clock size-3"></i> PENDING
                                                </span>
                                                <span class="text-xs opacity-60 mt-1 pl-1 italic">"<%= u.getStatusReason() %>"</span>
                                            </div>
                                        <% } %>
                                    </td>
                                    <td>
                                        <div class="font-medium opacity-70">
                                            <i class="lucide-calendar size-3 inline mr-1"></i>
                                            <%= u.getDateRegistered() %>
                                        </div>
                                    </td>
                                    <td>
                                        <form action="${pageContext.request.contextPath}/admin/users" method="post" class="flex gap-2 items-center m-0">
                                            <input type="hidden" name="action" value="updateLimit">
                                            <input type="hidden" name="username" value="<%= u.getUsername() %>">
                                            <div class="join shadow-sm border border-base-300">
                                                <input type="number" name="limit" value="<%= u.getBorrowLimit() %>" class="input input-sm join-item w-16 bg-base-100 font-bold" min="1" max="100">
                                                <button type="submit" class="btn btn-sm join-item btn-ghost">SET</button>
                                            </div>
                                        </form>
                                    </td>
                                    <td class="text-right">
                                        <% if (!"admin".equals(u.getUsername())) { %>
                                        <div class="flex justify-end gap-2">
                                            <form action="${pageContext.request.contextPath}/admin/users" method="post" class="inline m-0">
                                                <input type="hidden" name="username" value="<%= u.getUsername() %>">
                                                <% if (!"VERIFIED".equals(u.getStatus())) { %>
                                                    <button type="submit" name="action" value="verify" class="btn btn-sm btn-success text-white shadow-md hover-lift">
                                                        <i class="lucide-check-circle size-4 mr-1"></i> Approve
                                                    </button>
                                                <% } %>
                                                <% if ("BANNED".equals(u.getStatus())) { %>
                                                    <button type="submit" name="action" value="unban" class="btn btn-sm btn-info text-white shadow-md hover-lift">
                                                        <i class="lucide-unlock size-4 mr-1"></i> Unban
                                                    </button>
                                                <% } %>
                                            </form>
                                            
                                            <% if (!"BANNED".equals(u.getStatus())) { %>
                                                <button onclick="openBanModal('<%= u.getUsername() %>')" class="btn btn-sm btn-error shadow-md hover-lift">
                                                    <i class="lucide-ban size-4 mr-1"></i> Ban
                                                </button>
                                            <% } %>
                                        </div>
                                        <% } %>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%@ include file="/WEB-INF/jspf/sidebar.jspf" %>
</div>

<!-- Ban Modal -->
<dialog id="ban_modal" class="modal modal-bottom sm:modal-middle backdrop-blur-sm">
    <div class="modal-box glass-panel border border-white/40 rounded-3xl">
        <h3 class="font-black text-2xl flex items-center gap-3 text-error">
            <i class="lucide-alert-triangle size-8"></i> Restrict Account
        </h3>
        <p class="py-4 opacity-70">You are about to ban <span id="ban_target_name" class="font-bold text-base-content"></span>. Please provide a reason for this restriction.</p>
        
        <form action="${pageContext.request.contextPath}/admin/users" method="post">
            <input type="hidden" name="action" value="ban">
            <input type="hidden" id="ban_username_input" name="username" value="">
            
            <div class="form-control mb-6">
                <label class="label">
                    <span class="label-text font-bold uppercase tracking-widest text-xs opacity-50">Reason for Ban</span>
                </label>
                <textarea name="reason" placeholder="e.g., Multiple overdue books, Policy violation..." class="textarea textarea-bordered h-32 rounded-2xl bg-base-200/50 focus:border-error focus:ring-1 focus:ring-error" required></textarea>
            </div>
            
            <div class="modal-action flex gap-2">
                <button type="button" class="btn btn-ghost rounded-xl" onclick="ban_modal.close()">Cancel</button>
                <button type="submit" class="btn btn-error rounded-xl px-8 shadow-lg shadow-error/20">Confirm Ban</button>
            </div>
        </form>
    </div>
    <form method="dialog" class="modal-backdrop">
        <button>close</button>
    </form>
</dialog>

<script>
    lucide.createIcons();
    
    function openBanModal(username) {
        document.getElementById('ban_target_name').innerText = username;
        document.getElementById('ban_username_input').value = username;
        document.getElementById('ban_modal').showModal();
    }
</script>
</body>
</html>
