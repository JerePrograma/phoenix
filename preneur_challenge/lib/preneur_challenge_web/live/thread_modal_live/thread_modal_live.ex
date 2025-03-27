defmodule PreneurChallengeWeb.ThreadModalLive do
  use PreneurChallengeWeb, :live_view

  alias PreneurChallenge.Repo
  alias PreneurChallenge.Threads.Thread

  # Al montar el LiveView se carga la lista de threads existentes desde la base de datos
  # y se inicializan los asigns para el estado del modal.
  def mount(_params, _session, socket) do
    threads = Repo.all(Thread) |> Enum.map(& &1.content)

    {:ok,
     socket
     |> assign(:modal_open, false)
     |> assign(:new_post, "")
     |> assign(:threads, threads)}
  end

  #  Alterna el estado del modal (abre/cierra).
  def handle_event("toggle_modal", _params, socket) do
    {:noreply, assign(socket, :modal_open, !socket.assigns.modal_open)}
  end

  #  Actualiza el contenido del post mientras el usuario escribe.
  def handle_event("update_post", %{"new_post" => new_post}, socket) do
    {:noreply, assign(socket, :new_post, new_post)}
  end

  # Crea un nuevo thread.

  # - Si el contenido está vacío, se muestra un flash de error.
  # - Si se inserta correctamente, se recarga la lista de threads desde la base de datos,
  #   se limpia el campo, se cierra el modal y se muestra un flash de éxito.
  def handle_event("create_post", _params, socket) do
    new_thread_content = String.trim(socket.assigns.new_post)

    if new_thread_content == "" do
      {:noreply, put_flash(socket, :error, "El post no puede estar vacío")}
    else
      changeset = Thread.changeset(%Thread{}, %{content: new_thread_content})

      case Repo.insert(changeset) do
        {:ok, _thread} ->
          threads = Repo.all(Thread) |> Enum.map(& &1.content)

          {:noreply,
           socket
           |> assign(:threads, threads)
           |> assign(:new_post, "")
           |> assign(:modal_open, false)
           |> put_flash(:info, "Post creado con éxito")}

        {:error, _changeset} ->
          {:noreply, put_flash(socket, :error, "Error al crear el post")}
      end
    end
  end
end
