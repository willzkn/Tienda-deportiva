<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="es">

        <head>
            <%@ include file="includes/appHead.jspf" %>
                <title>Gestión de Usuarios - Admin</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-common.css" />
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/headerAdmin.css" />
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/adminproductos.css" />
        </head>

        <body>
            <%@ include file="includes/headerAdmin.jspf" %>

                <main class="container">
                    <section class="management-panel">
                        <div class="panel-header">
                            <h2>Gestión de Usuarios</h2>
                            <button class="btn btn-add" id="addUserBtn">
                                <i class="fa-solid fa-plus"></i>
                                Agregar Nuevo Usuario
                            </button>
                        </div>

                        <c:if test="${not empty success}">
                            <div
                                style="background-color: #d4edda; color: #155724; padding: 12px; margin: 15px 0; border: 1px solid #c3e6cb; border-radius: 4px;">
                                ${success}
                            </div>
                        </c:if>

                        <c:if test="${not empty error}">
                            <div
                                style="background-color: #f8d7da; color: #721c24; padding: 12px; margin: 15px 0; border: 1px solid #f5c6cb; border-radius: 4px;">
                                ${error}
                            </div>
                        </c:if>

                        <div class="table-container">
                            <table class="products-table">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Correo Electrónico</th>
                                        <th>Rol</th>
                                        <th>Estado (Click para cambiar)</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="usuario" items="${usuarios}">
                                        <tr>
                                            <td>${usuario.id_usuario}</td>
                                            <td>${usuario.correo}</td>
                                            <td>
                                                <span class="status"
                                                    style="background-color: ${usuario.rol == 'Admin' ? '#dc3545' : '#0d6efd'}; color: white; padding: 4px 8px; border-radius: 4px; font-size: 0.85rem;">
                                                    ${usuario.rol}
                                                </span>
                                            </td>
                                            <td>
                                                <!-- Botón Toggle de Estado -->
                                                <form
                                                    action="${pageContext.request.contextPath}/admin/usuarios/cambiar-estado"
                                                    method="post" style="display:inline;">
                                                    <input type="hidden" name="id" value="${usuario.id_usuario}">
                                                    <input type="hidden" name="activo" value="${!usuario.activo}">

                                                    <button type="submit" class="btn"
                                                        style="background-color: ${usuario.activo ? '#28a745' : '#dc3545'}; color: white; border: none; padding: 6px 12px; cursor: pointer; border-radius: 4px; min-width: 90px; font-weight: 600;"
                                                        title="Click para ${usuario.activo ? 'desactivar' : 'activar'}">
                                                        ${usuario.activo ? 'ACTIVO' : 'INACTIVO'}
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </section>
                </main>

                <!-- Modal para Agregar Usuario -->
                <div id="addUserModal" class="modal" style="display: none;">
                    <div class="modal-content" style="max-width: 500px;">
                        <span class="close-button">&times;</span>
                        <h2>Agregar Nuevo Usuario</h2>
                        <form id="addUserForm" action="${pageContext.request.contextPath}/admin/usuarios/guardar"
                            method="post">
                            <div class="modal-body">
                                <div style="margin-bottom: 15px;">
                                    <label for="correo"
                                        style="display: block; margin-bottom: 5px; font-weight: 500;">Correo
                                        Electrónico:</label>
                                    <input type="email" name="correo" id="correo" placeholder="ejemplo@correo.com"
                                        required
                                        style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px;">
                                </div>

                                <div style="margin-bottom: 15px;">
                                    <label for="clave"
                                        style="display: block; margin-bottom: 5px; font-weight: 500;">Contraseña:</label>
                                    <input type="password" name="clave" id="clave" placeholder="Contraseña" required
                                        style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px;">
                                </div>

                                <div style="margin-bottom: 15px;">
                                    <label for="rol"
                                        style="display: block; margin-bottom: 5px; font-weight: 500;">Rol:</label>
                                    <select name="rol" id="rol" required
                                        style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px;">
                                        <option value="Cliente">Cliente</option>
                                        <option value="Admin">Administrador</option>
                                    </select>
                                </div>
                            </div>
                            <div class="modal-footer"
                                style="display: flex; justify-content: flex-end; gap: 10px; margin-top: 20px;">
                                <button type="button" class="btn btn-cancel"
                                    style="background-color: #6c757d; color: white;">Cancelar</button>
                                <button type="submit" class="btn btn-add">Guardar Usuario</button>
                            </div>
                        </form>
                    </div>
                </div>

                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        const modal = document.getElementById('addUserModal');
                        const addBtn = document.getElementById('addUserBtn');
                        const closeBtn = document.querySelector('.close-button');
                        const cancelBtn = document.querySelector('.btn-cancel');

                        if (addBtn) {
                            addBtn.onclick = () => modal.style.display = 'flex';
                        }
                        if (closeBtn) {
                            closeBtn.onclick = () => modal.style.display = 'none';
                        }
                        if (cancelBtn) {
                            cancelBtn.onclick = () => modal.style.display = 'none';
                        }
                        window.onclick = (event) => {
                            if (event.target == modal) {
                                modal.style.display = 'none';
                            }
                        }
                    });
                </script>
        </body>

        </html>