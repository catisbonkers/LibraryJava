<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.demo1.model.User" %>
<html>
<head>
    <title>Account Status | LibraSync</title>
    <%@ include file="/WEB-INF/jspf/head.jspf" %>
</head>
<body class="flex items-center justify-center p-4 overflow-hidden">
    <!-- Animated Background Orbs -->
    <div class="fixed inset-0 -z-10 overflow-hidden">
        <div class="absolute top-[-10%] left-[-10%] w-[40%] h-[40%] bg-primary/20 blur-[120px] rounded-full animate-pulse"></div>
        <div class="absolute bottom-[-10%] right-[-10%] w-[40%] h-[40%] bg-secondary/20 blur-[120px] rounded-full animate-pulse" style="animation-delay: 2s"></div>
    </div>

    <%
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String status = user.getStatus();
        String reason = user.getStatusReason();
        boolean isBanned = "BANNED".equals(status);
    %>

    <div class="max-w-md w-full glass-panel rounded-[2.5rem] p-10 text-center relative border border-white/40 shadow-[0_32px_64px_-12px_rgba(0,0,0,0.1)] animate-in fade-in slide-in-from-bottom-8 duration-700 ease-out">
        <div class="mb-8 relative inline-block">
            <% if (isBanned) { %>
                <div class="w-24 h-24 bg-error/10 text-error rounded-3xl flex items-center justify-center mx-auto mb-6 rotate-3 hover:rotate-0 transition-transform duration-500">
                    <i class="lucide-shield-off size-12"></i>
                </div>
                <div class="badge badge-error font-black uppercase tracking-widest px-4 py-3 shadow-lg shadow-error/20">ACCOUNT BANNED</div>
            <% } else { %>
                <div class="w-24 h-24 bg-warning/10 text-warning rounded-3xl flex items-center justify-center mx-auto mb-6 -rotate-3 hover:rotate-0 transition-transform duration-500">
                    <i class="lucide-shield-alert size-12"></i>
                </div>
                <div class="badge badge-warning font-black uppercase tracking-widest px-4 py-3 shadow-lg shadow-warning/20">VERIFICATION REQUIRED</div>
            <% } %>
        </div>

        <div class="space-y-6 mb-10">
            <div>
                <h1 class="text-4xl font-black tracking-tight text-base-content mb-2">Access Restricted</h1>
                <p class="text-base-content/60 font-medium">
                    Hello <span class="text-primary font-bold"><%= user.getUsername() %></span>, your account access has been limited by the administration.
                </p>
            </div>
            
            <div class="bg-white/50 backdrop-blur-md p-6 rounded-3xl border border-white/60 shadow-inner group transition-all hover:bg-white/80">
                <span class="text-[10px] uppercase tracking-[0.2em] font-black opacity-40 block mb-3 text-center">Official Reasoning</span>
                <p class="text-xl font-bold italic text-base-content leading-relaxed">
                    "<%= reason != null ? reason : "Standard security review in progress." %>"
                </p>
            </div>
        </div>

        <div class="grid grid-cols-1 gap-4">
            <% if (isBanned) { %>
                <button onclick="this.innerHTML='<i class=\'lucide-check size-4 mr-2\'></i> Appeal Sent'; this.classList.add('btn-disabled')" class="btn btn-error btn-lg rounded-2xl w-full hover-lift font-black shadow-xl shadow-error/20">
                    <i class="lucide-send size-5 mr-2"></i> SUBMIT APPEAL
                </button>
            <% } else { %>
                <button onclick="this.innerHTML='<i class=\'lucide-check size-4 mr-2\'></i> Request Sent'; this.classList.add('btn-disabled')" class="btn btn-warning btn-lg rounded-2xl w-full hover-lift font-black shadow-xl shadow-warning/20 text-warning-content">
                    <i class="lucide-refresh-cw size-5 mr-2"></i> REQUEST REVIEW
                </button>
            <% } %>
            
            <div class="flex gap-4">
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-ghost flex-1 rounded-2xl font-bold opacity-60 hover:opacity-100">
                    <i class="lucide-log-out size-4 mr-2"></i> SIGN OUT
                </a>
                <button onclick="window.location.reload()" class="btn btn-ghost flex-none rounded-2xl aspect-square p-0 w-14 opacity-40 hover:opacity-100">
                    <i class="lucide-refresh-ccw size-5"></i>
                </button>
            </div>
        </div>
        
        <div class="mt-10 pt-8 border-t border-white/40 flex flex-col items-center gap-4">
            <div class="flex -space-x-2">
                <div class="w-8 h-8 rounded-full border-2 border-white bg-base-300"></div>
                <div class="w-8 h-8 rounded-full border-2 border-white bg-base-200"></div>
                <div class="w-8 h-8 rounded-full border-2 border-white bg-base-100 flex items-center justify-center text-[10px] font-bold">+3</div>
            </div>
            <p class="text-[10px] font-black uppercase tracking-widest opacity-30">
                Contacting support@librasync.com
            </p>
        </div>
    </div>

    <script>
        // Initialize Lucide icons
        lucide.createIcons();
    </script>
</body>
</html>
