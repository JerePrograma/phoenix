defmodule PreneurChallengeWeb.ThreadModalLive do
  use PreneurChallengeWeb, :live_view

  alias PreneurChallenge.Repo
  alias PreneurChallenge.Threads.Thread
  alias PreneurChallenge.Accounts.User

  # Al montar el LiveView se cargan los threads con información adicional
  def mount(_params, _session, socket) do
    # Obtener threads con información adicional (usuario, timestamp, etc.)
    threads_with_details = get_threads_with_details()

    {:ok,
     socket
     |> assign(:modal_open, false)
     |> assign(:new_post, "")
     |> assign(:threads, threads_with_details)
     |> assign(:new_post_added, false)
     |> assign(:current_user, get_mock_current_user())
     |> assign(:suggested_users, get_suggested_users())
     |> assign(:likes, %{})
     |> assign(:comments_open, %{})
     |> assign(:comment_text, %{})}
  end

  # Alterna el estado del modal (abre/cierra)
  def handle_event("toggle_modal", _params, socket) do
    {:noreply, assign(socket, :modal_open, !socket.assigns.modal_open)}
  end

  # Actualiza el contenido del post mientras el usuario escribe
  def handle_event("update_post", %{"new_post" => new_post}, socket) do
    {:noreply, assign(socket, :new_post, new_post)}
  end

  # Crea un nuevo thread con animación
  def handle_event("create_post", _params, socket) do
    new_thread_content = String.trim(socket.assigns.new_post)

    if new_thread_content == "" do
      {:noreply, put_flash(socket, :error, "El post no puede estar vacío")}
    else
      # Simulamos la creación del thread con el usuario actual
      current_user = socket.assigns.current_user

      # Crear un nuevo thread con timestamp actual
      new_thread = %{
        id: System.unique_integer([:positive]),
        content: new_thread_content,
        user: current_user,
        likes_count: 0,
        comments_count: 0,
        inserted_at: DateTime.utc_now(),
        is_new: true
      }

      # Añadir el nuevo thread al principio de la lista
      updated_threads = [new_thread | socket.assigns.threads]

      # Programar la eliminación de la clase de animación
      Process.send_after(self(), {:remove_animation, new_thread.id}, 1000)

      {:noreply,
       socket
       |> assign(:threads, updated_threads)
       |> assign(:new_post, "")
       |> assign(:modal_open, false)
       |> assign(:new_post_added, true)
       |> put_flash(:info, "Post creado con éxito")}
    end
  end

  # Maneja el evento de dar like a un post
  def handle_event("toggle_like", %{"id" => id}, socket) do
    id = String.to_integer(id)
    current_likes = socket.assigns.likes

    # Toggle like status
    updated_likes = Map.update(current_likes, id, true, &(!&1))

    # Update like count in the thread
    updated_threads =
      Enum.map(socket.assigns.threads, fn thread ->
        if thread.id == id do
          likes_count =
            if Map.get(updated_likes, id, false),
              do: thread.likes_count + 1,
              else: thread.likes_count - 1

          %{thread | likes_count: likes_count}
        else
          thread
        end
      end)

    {:noreply,
     socket
     |> assign(:likes, updated_likes)
     |> assign(:threads, updated_threads)}
  end

  # Maneja el evento de abrir/cerrar la sección de comentarios
  def handle_event("toggle_comments", %{"id" => id}, socket) do
    id = String.to_integer(id)
    current_comments_open = socket.assigns.comments_open

    # Toggle comments visibility
    updated_comments_open = Map.update(current_comments_open, id, true, &(!&1))

    {:noreply, assign(socket, :comments_open, updated_comments_open)}
  end

  # Actualiza el texto del comentario mientras el usuario escribe
  def handle_event("update_comment", %{"id" => id, "comment" => comment}, socket) do
    id = String.to_integer(id)
    updated_comment_text = Map.put(socket.assigns.comment_text, id, comment)

    {:noreply, assign(socket, :comment_text, updated_comment_text)}
  end

  # Añade un comentario a un thread
  def handle_event("add_comment", %{"id" => id}, socket) do
    id = String.to_integer(id)
    comment_text = Map.get(socket.assigns.comment_text, id, "")

    if String.trim(comment_text) == "" do
      {:noreply, put_flash(socket, :error, "El comentario no puede estar vacío")}
    else
      # Update comment count in the thread
      updated_threads =
        Enum.map(socket.assigns.threads, fn thread ->
          if thread.id == id do
            %{thread | comments_count: thread.comments_count + 1}
          else
            thread
          end
        end)

      # Clear comment text
      updated_comment_text = Map.put(socket.assigns.comment_text, id, "")

      {:noreply,
       socket
       |> assign(:threads, updated_threads)
       |> assign(:comment_text, updated_comment_text)
       |> put_flash(:info, "Comentario añadido")}
    end
  end

  # Maneja el evento de seguir a un usuario
  def handle_event("follow_user", %{"id" => id}, socket) do
    # Actualizar la lista de usuarios sugeridos para marcar al usuario como seguido
    updated_suggested_users =
      Enum.map(socket.assigns.suggested_users, fn user ->
        if user.id == String.to_integer(id) do
          %{user | following: true}
        else
          user
        end
      end)

    {:noreply,
     socket
     |> assign(:suggested_users, updated_suggested_users)
     |> put_flash(:info, "¡Usuario seguido con éxito!")}
  end

  # Elimina la animación después de un tiempo
  def handle_info({:remove_animation, thread_id}, socket) do
    updated_threads =
      Enum.map(socket.assigns.threads, fn thread ->
        if thread.id == thread_id do
          Map.put(thread, :is_new, false)
        else
          thread
        end
      end)

    {:noreply, assign(socket, :threads, updated_threads)}
  end

  # Funciones auxiliares para obtener datos simulados

  defp get_threads_with_details do
    # Simulamos threads con información adicional
    [
      %{
        id: 1,
        content:
          "¡Hola a todos! Este es mi primer post en Threads. Estoy emocionado de unirme a esta comunidad.",
        user: %{id: 1, username: "usuario", avatar: "/images/foto_perfil.png"},
        likes_count: 12,
        comments_count: 3,
        inserted_at: ~U[2023-04-01 10:30:00Z],
        is_new: false
      },
      %{
        id: 2,
        content: "Acabo de lanzar mi nuevo proyecto. ¡Échale un vistazo y dime qué te parece!",
        user: %{id: 2, username: "emprendedor", avatar: "/images/foto_perfil.png"},
        likes_count: 24,
        comments_count: 7,
        inserted_at: ~U[2023-04-01 09:15:00Z],
        is_new: false
      },
      %{
        id: 3,
        content:
          "La programación es como la poesía: cada línea importa, cada espacio tiene significado, y la belleza está en la simplicidad.",
        user: %{id: 3, username: "dev_poeta", avatar: "/images/foto_perfil.png"},
        likes_count: 45,
        comments_count: 12,
        inserted_at: ~U[2023-03-31 22:45:00Z],
        is_new: false
      }
    ]
  end

  defp get_mock_current_user do
    %{id: 1, username: "usuario", avatar: "/images/foto_perfil.png"}
  end

  defp get_suggested_users do
    [
      %{
        id: 4,
        username: "usuario1",
        display_name: "Usuario Uno",
        avatar: "/images/foto_perfil.png",
        following: false
      },
      %{
        id: 5,
        username: "usuario2",
        display_name: "Usuario Dos",
        avatar: "/images/foto_perfil.png",
        following: false
      },
      %{
        id: 6,
        username: "usuario3",
        display_name: "Usuario Tres",
        avatar: "/images/foto_perfil.png",
        following: false
      }
    ]
  end

  # Función para formatear la fecha relativa
  defp format_relative_time(datetime) do
    now = DateTime.utc_now()
    diff_seconds = DateTime.diff(now, datetime)

    cond do
      diff_seconds < 60 -> "hace #{diff_seconds}s"
      diff_seconds < 3600 -> "hace #{div(diff_seconds, 60)}m"
      diff_seconds < 86400 -> "hace #{div(diff_seconds, 3600)}h"
      diff_seconds < 604_800 -> "hace #{div(diff_seconds, 86400)}d"
      true -> "hace #{div(diff_seconds, 604_800)}sem"
    end
  end
end
