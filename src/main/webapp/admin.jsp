<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.demo1.service.BookService" %>
<%@ page import="com.example.demo1.service.SettingsService" %>
<%@ page import="com.example.demo1.model.Book" %>
<%@ page import="java.util.List" %>
<html data-theme="light">
<head>
    <title>Admin Panel | LibraSync</title>
    <%@ include file="/WEB-INF/jspf/head.jspf" %>
</head>
<body class="bg-base-200">
<div id="toastContainer" class="toast toast-top toast-end z-50"></div>

<%
    com.example.demo1.model.User user =
            (com.example.demo1.model.User) session.getAttribute("user");

    if (user == null || !user.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
        return;
    }

    List<Book> books = BookService.getAllBooks();
%>

<div class="drawer lg:drawer-open">
    <input id="drawer" type="checkbox" class="drawer-toggle" />
    <div class="drawer-content flex flex-col min-h-screen">

        <!-- Navbar -->
        <div class="navbar bg-base-100/70 backdrop-blur-md sticky top-0 z-30 shadow-sm border-b border-base-200">
            <label for="drawer" class="btn btn-square btn-ghost lg:hidden">
                <i data-lucide="menu" class="w-5 h-5"></i>
            </label>
            <div class="px-4 text-lg font-bold bg-clip-text bg-gradient-to-r from-primary to-secondary">
                Admin Control
            </div>
            <div class="ml-auto flex items-center gap-4 px-4">
                <div class="text-sm font-medium">
                    <span class="opacity-70">Admin,</span>
                    <span class="font-bold text-primary"><%= user.getUsername() %></span>
                    <div class="badge badge-error badge-outline badge-sm ml-2">ADMIN</div>
                </div>
            </div>
        </div>

        <!-- Main Content -->
        <div class="p-8 flex-1 overflow-y-auto">

            <!-- Page Header -->
            <div class="flex items-center justify-between mb-8">
                <div>
                    <h1 class="text-3xl font-bold text-base-content flex items-center gap-3">
                        <i data-lucide="shield-check" class="w-8 h-8 text-primary"></i>
                        Library Administration
                    </h1>
                    <p class="text-base-content/60 mt-1 ml-11">Manage the library catalog and system settings.</p>
                </div>
                <div class="flex gap-2">
                    <button class="btn btn-secondary gap-2 hover-lift shadow-md"
                            onclick="document.getElementById('settingsModal').showModal()">
                        <i data-lucide="settings" class="w-4 h-4"></i>
                        Settings
                    </button>
                    <!-- Open Add Book Modal -->
                    <button class="btn btn-primary gap-2 hover-lift shadow-md"
                            onclick="document.getElementById('addBookModal').showModal()">
                        <i data-lucide="plus-circle" class="w-4 h-4"></i>
                        Add New Book
                    </button>
                </div>
            </div>

            <!-- Book Inventory Table -->
            <div class="glass-panel rounded-2xl overflow-hidden shadow-sm">
                <div class="flex items-center justify-between p-5 bg-base-200/60 border-b border-base-300">
                    <h3 class="font-bold text-lg flex items-center gap-2">
                        <i data-lucide="library-big" class="w-5 h-5 text-primary"></i>
                        Current Inventory
                    </h3>
                    <div class="badge badge-primary badge-outline font-semibold">
                        <%= books.size() %> <%= books.size() == 1 ? "title" : "titles" %>
                    </div>
                </div>

                <% if (books.isEmpty()) { %>
                <div class="p-16 text-center">
                    <i data-lucide="package-x" class="w-16 h-16 mx-auto mb-4 text-base-content/20"></i>
                    <p class="font-semibold text-base-content/50 text-lg">No books in the library yet</p>
                    <p class="text-sm text-base-content/40 mt-1 mb-6">Get started by adding your first book.</p>
                    <button class="btn btn-primary btn-sm gap-2"
                            onclick="document.getElementById('addBookModal').showModal()">
                        <i data-lucide="plus" class="w-4 h-4"></i>
                        Add First Book
                    </button>
                </div>
                <% } else { %>
                <div class="overflow-x-auto">
                    <table class="table w-full">
                        <thead class="bg-base-200/60 text-base-content/70">
                        <tr>
                            <th class="font-semibold text-xs uppercase tracking-wider">
                                <div class="flex items-center gap-1">
                                    <i data-lucide="fingerprint" class="w-3 h-3"></i> ID
                                </div>
                            </th>
                            <th class="font-semibold text-xs uppercase tracking-wider">
                                <div class="flex items-center gap-1">
                                    <i data-lucide="book" class="w-3 h-3"></i> Title
                                </div>
                            </th>
                            <th class="font-semibold text-xs uppercase tracking-wider">
                                <div class="flex items-center gap-1">
                                    <i data-lucide="user-pen" class="w-3 h-3"></i> Author
                                </div>
                            </th>
                            <th class="font-semibold text-xs uppercase tracking-wider text-center">
                                <div class="flex items-center justify-center gap-1">
                                    <i data-lucide="layers" class="w-3 h-3"></i> Stock
                                </div>
                            </th>
                            <th class="font-semibold text-xs uppercase tracking-wider text-center">
                                <div class="flex items-center justify-center gap-1">
                                    <i data-lucide="activity" class="w-3 h-3"></i> Status
                                </div>
                            </th>
                            <th class="font-semibold text-xs uppercase tracking-wider text-center">
                                <div class="flex items-center justify-center gap-1">
                                    <i data-lucide="settings-2" class="w-3 h-3"></i> Actions
                                </div>
                            </th>
                        </tr>
                        </thead>
                        <tbody>
                        <% for (Book b : books) { %>
                        <tr class="hover:bg-base-100/60 transition-colors border-b border-base-200">
                            <td class="font-mono text-xs text-base-content/40"><%= b.getId().substring(0, 8) %>...</td>
                            <td class="font-semibold"><%= b.getTitle() %></td>
                            <td class="text-base-content/70"><%= b.getAuthor() %></td>
                            <td class="text-center">
                                <span class="font-bold text-lg <%= b.getStock() < 3 ? "text-warning" : "text-base-content" %>">
                                    <%= b.getStock() %>
                                </span>
                            </td>
                            <td class="text-center">
                                <% if (b.getStock() > 0) { %>
                                <span class="badge badge-success badge-outline badge-sm font-medium gap-1">
                                    <i data-lucide="check-circle" class="w-3 h-3"></i> In Stock
                                </span>
                                <% } else { %>
                                <span class="badge badge-error badge-outline badge-sm font-medium gap-1">
                                    <i data-lucide="x-circle" class="w-3 h-3"></i> Depleted
                                </span>
                                <% } %>
                            </td>
                            <td class="text-center">
                                <div class="flex items-center justify-center gap-2">
                                    <button class="btn btn-xs btn-info btn-outline gap-1"
                                        onclick="openEditModal(
                                            '<%= b.getId() %>',
                                            '<%= b.getTitle().replace("\\", "\\\\").replace("'", "\\'") %>',
                                            '<%= b.getAuthor().replace("\\", "\\\\").replace("'", "\\'") %>',
                                            '<%= b.getPublisher() != null ? b.getPublisher().replace("\\", "\\\\").replace("'", "\\'") : "" %>',
                                            <%= b.getPublishYear() %>,
                                            <%= b.getStock() %>,
                                            '<%= b.getDescription() != null ? b.getDescription().replace("\\", "\\\\").replace("'", "\\'").replace("\n", "\\n").replace("\r", "") : "" %>'
                                        )">
                                        <i data-lucide="pencil" class="w-3 h-3"></i>
                                        Edit
                                    </button>
                                    <button class="btn btn-xs btn-error btn-outline gap-1"
                                        onclick="openDeleteModal(
                                            '<%= b.getId() %>',
                                            '<%= b.getTitle().replace("\\", "\\\\").replace("'", "\\'") %>'
                                        )">
                                        <i data-lucide="trash-2" class="w-3 h-3"></i>
                                        Delete
                                    </button>
                                </div>
                            </td>
                        </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
                <% } %>
            </div>

        </div>
    </div>

    <%@ include file="/WEB-INF/jspf/sidebar.jspf" %>
</div>

<!-- ===== ADD BOOK MODAL ===== -->
<dialog id="addBookModal" class="modal modal-bottom sm:modal-middle">
    <div class="modal-box glass-panel max-w-lg">
        <div class="flex items-center gap-3 mb-6">
            <div class="p-2 bg-primary/10 rounded-xl">
                <i data-lucide="book-plus" class="w-6 h-6 text-primary"></i>
            </div>
            <div>
                <h3 class="font-bold text-xl">Add New Book</h3>
                <p class="text-sm text-base-content/60">Fill in the details to add a book to the catalog.</p>
            </div>
        </div>
        <form action="<%= request.getContextPath() %>/add-book" method="post" enctype="multipart/form-data" class="flex flex-col gap-4">
            <div class="form-control w-full">
                <label class="label"><span class="label-text font-medium">Book Title</span></label>
                <input type="text" name="title" placeholder="e.g. The Pragmatic Programmer"
                       class="input input-bordered w-full" required autofocus />
            </div>
            <div class="form-control w-full">
                <label class="label"><span class="label-text font-medium">Author</span></label>
                <input type="text" name="author" placeholder="e.g. David Thomas"
                       class="input input-bordered w-full" required />
            </div>
            <div class="flex gap-4">
                <div class="form-control w-1/2">
                    <label class="label"><span class="label-text font-medium">Publisher</span></label>
                    <input type="text" name="publisher" placeholder="e.g. Addison-Wesley"
                           class="input input-bordered w-full" required />
                </div>
                <div class="form-control w-1/2">
                    <label class="label"><span class="label-text font-medium">Publish Year</span></label>
                    <input type="number" name="publishYear" min="1000" max="2100" value="2024"
                           class="input input-bordered w-full" required />
                </div>
            </div>
            <div class="form-control w-full">
                <label class="label"><span class="label-text font-medium">Synopsis</span></label>
                <textarea name="description" placeholder="A brief description of the book..." class="textarea textarea-bordered w-full" rows="3" required></textarea>
            </div>
            <div class="flex gap-4">
                <div class="form-control w-1/3">
                    <label class="label"><span class="label-text font-medium">Initial Stock</span></label>
                    <input type="number" name="stock" min="1" value="1"
                           class="input input-bordered w-full" required />
                </div>
                <div class="form-control w-2/3">
                    <label class="label"><span class="label-text font-medium">Cover Image (Optional)</span></label>
                    <input type="file" name="coverImage" accept="image/*" class="file-input file-input-bordered w-full" />
                </div>
            </div>
            <div class="modal-action mt-2">
                <button type="button" class="btn btn-ghost gap-2"
                        onclick="document.getElementById('addBookModal').close()">
                    <i data-lucide="x" class="w-4 h-4"></i> Cancel
                </button>
                <button type="submit" class="btn btn-primary gap-2">
                    <i data-lucide="plus-circle" class="w-4 h-4"></i> Add Book
                </button>
            </div>
        </form>
    </div>
    <form method="dialog" class="modal-backdrop"><button>close</button></form>
</dialog>

<!-- ===== EDIT BOOK MODAL ===== -->
<dialog id="editBookModal" class="modal modal-bottom sm:modal-middle">
    <div class="modal-box glass-panel max-w-lg">
        <div class="flex items-center gap-3 mb-6">
            <div class="p-2 bg-info/10 rounded-xl">
                <i data-lucide="pencil" class="w-6 h-6 text-info"></i>
            </div>
            <div>
                <h3 class="font-bold text-xl">Edit Book</h3>
                <p class="text-sm text-base-content/60">Update the book's information below.</p>
            </div>
        </div>
        <form action="<%= request.getContextPath() %>/edit-book" method="post" enctype="multipart/form-data" class="flex flex-col gap-4">
            <input type="hidden" id="editBookId" name="bookId" />
            <div class="form-control w-full">
                <label class="label"><span class="label-text font-medium">Book Title</span></label>
                <input type="text" id="editTitle" name="title" class="input input-bordered w-full" required />
            </div>
            <div class="form-control w-full">
                <label class="label"><span class="label-text font-medium">Author</span></label>
                <input type="text" id="editAuthor" name="author" class="input input-bordered w-full" required />
            </div>
            <div class="flex gap-4">
                <div class="form-control w-1/2">
                    <label class="label"><span class="label-text font-medium">Publisher</span></label>
                    <input type="text" id="editPublisher" name="publisher" class="input input-bordered w-full" required />
                </div>
                <div class="form-control w-1/2">
                    <label class="label"><span class="label-text font-medium">Publish Year</span></label>
                    <input type="number" id="editPublishYear" name="publishYear" min="1000" max="2100" class="input input-bordered w-full" required />
                </div>
            </div>
            <div class="form-control w-full">
                <label class="label"><span class="label-text font-medium">Synopsis</span></label>
                <textarea id="editDescription" name="description" class="textarea textarea-bordered w-full" rows="3" required></textarea>
            </div>
            <div class="flex gap-4">
                <div class="form-control w-1/3">
                    <label class="label"><span class="label-text font-medium">Stock Quantity</span></label>
                    <input type="number" id="editStock" name="stock" min="0" class="input input-bordered w-full" required />
                </div>
                <div class="form-control w-2/3">
                    <label class="label"><span class="label-text font-medium">New Cover (Optional)</span></label>
                    <input type="file" name="coverImage" accept="image/*" class="file-input file-input-bordered w-full" />
                </div>
            </div>
            <div class="modal-action mt-2">
                <button type="button" class="btn btn-ghost gap-2"
                        onclick="document.getElementById('editBookModal').close()">
                    <i data-lucide="x" class="w-4 h-4"></i> Cancel
                </button>
                <button type="submit" class="btn btn-info gap-2">
                    <i data-lucide="save" class="w-4 h-4"></i> Save Changes
                </button>
            </div>
        </form>
    </div>
    <form method="dialog" class="modal-backdrop"><button>close</button></form>
</dialog>

<!-- ===== DELETE CONFIRM MODAL ===== -->
<dialog id="deleteBookModal" class="modal modal-bottom sm:modal-middle">
    <div class="modal-box glass-panel max-w-sm">
        <div class="flex items-center gap-3 mb-4">
            <div class="p-2 bg-error/10 rounded-xl">
                <i data-lucide="triangle-alert" class="w-6 h-6 text-error"></i>
            </div>
            <div>
                <h3 class="font-bold text-xl">Delete Book</h3>
                <p class="text-sm text-base-content/60">This action cannot be undone.</p>
            </div>
        </div>
        <p class="text-base-content/80 mb-1">Are you sure you want to delete:</p>
        <p id="deleteBookTitle" class="font-bold text-lg text-error mb-6"></p>
        <form id="deleteBookForm" action="<%= request.getContextPath() %>/delete-book" method="post">
            <input type="hidden" id="deleteBookId" name="bookId" />
            <div class="modal-action mt-0">
                <button type="button" class="btn btn-ghost gap-2"
                        onclick="document.getElementById('deleteBookModal').close()">
                    <i data-lucide="x" class="w-4 h-4"></i> Cancel
                </button>
                <button type="submit" class="btn btn-error gap-2">
                    <i data-lucide="trash-2" class="w-4 h-4"></i> Delete
                </button>
            </div>
        </form>
    </div>
    <form method="dialog" class="modal-backdrop"><button>close</button></form>
</dialog>

<!-- ===== SETTINGS MODAL ===== -->
<dialog id="settingsModal" class="modal modal-bottom sm:modal-middle">
    <div class="modal-box glass-panel max-w-md">
        <div class="flex items-center gap-3 mb-6">
            <div class="p-2 bg-secondary/10 rounded-xl">
                <i data-lucide="settings" class="w-6 h-6 text-secondary"></i>
            </div>
            <div>
                <h3 class="font-bold text-xl">Library Settings</h3>
                <p class="text-sm text-base-content/60">Configure global library rules.</p>
            </div>
        </div>
        <form action="<%= request.getContextPath() %>/update-settings" method="post" class="flex flex-col gap-4">
            <div class="form-control w-full">
                <label class="label">
                    <span class="label-text font-medium">Overdue Penalty (per day)</span>
                </label>
                <label class="input input-bordered flex items-center gap-2">
                    $
                    <input type="number" name="penalty" step="0.01" min="0" 
                           value="<%= SettingsService.getPenaltyPerDay() %>" class="grow" required />
                </label>
            </div>
            <div class="modal-action mt-2">
                <button type="button" class="btn btn-ghost gap-2"
                        onclick="document.getElementById('settingsModal').close()">
                    <i data-lucide="x" class="w-4 h-4"></i> Cancel
                </button>
                <button type="submit" class="btn btn-secondary gap-2">
                    <i data-lucide="save" class="w-4 h-4"></i> Save Settings
                </button>
            </div>
        </form>
    </div>
    <form method="dialog" class="modal-backdrop"><button>close</button></form>
</dialog>

<script>
    function openEditModal(id, title, author, publisher, publishYear, stock, description) {
        document.getElementById('editBookId').value = id;
        document.getElementById('editTitle').value = title;
        document.getElementById('editAuthor').value = author;
        document.getElementById('editPublisher').value = publisher;
        document.getElementById('editPublishYear').value = publishYear;
        document.getElementById('editStock').value = stock;
        document.getElementById('editDescription').value = description;
        document.getElementById('editBookModal').showModal();
    }

    function openDeleteModal(id, title) {
        document.getElementById('deleteBookId').value = id;
        document.getElementById('deleteBookTitle').textContent = '"' + title + '"';
        document.getElementById('deleteBookModal').showModal();
    }

    function showToast(message, type) {
        const container = document.getElementById("toastContainer");
        if (!container) return;
        const toast = document.createElement("div");
        toast.className = "alert alert-" + type + " shadow-lg";
        toast.innerHTML = "<span>" + message + "</span>";
        container.appendChild(toast);
        setTimeout(() => toast.remove(), 3500);
    }

    document.addEventListener("DOMContentLoaded", function () {
        // Render all lucide icons
        lucide.createIcons();

        const error = '<%= (String) session.getAttribute("error") != null ? session.getAttribute("error") : "" %>';
        const success = '<%= (String) session.getAttribute("success") != null ? session.getAttribute("success") : "" %>';

        if (error) showToast(error, "error");
        if (success) showToast(success, "success");
    });
</script>

<%
    session.removeAttribute("error");
    session.removeAttribute("success");
%>
</body>
</html>
