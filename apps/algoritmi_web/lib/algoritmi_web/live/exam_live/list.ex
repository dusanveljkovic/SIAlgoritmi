defmodule AlgoritmiWeb.ExamLive.List do
  use AlgoritmiWeb, :live_view

  alias Algoritmi.Posts

  @impl true
  def mount(_params, _session, socket) do
    exams = Posts.list_exams()
    filters = Posts.Exam.empty_filter()
    {:ok, socket
      |> assign(:base_list, exams)
      |> assign(:filters, filters)
      |> assign(:visible, exams)} 
  end

  @impl true
  def handle_event("filter", %{"field" => field, "val" => value}, socket) do
    field_atom = String.to_existing_atom(field)
    filters = socket.assigns.filters
    field_filter = Map.get(filters, field_atom)

    new_filter = 
      if value in field_filter do
        List.delete(field_filter, value)
      else
        [value | field_filter]
      end
    
    new_filters = Map.put(filters, field_atom, new_filter)
    {:noreply, socket
      |> assign(:filters, new_filters)
      |> apply_filters()}
  end

  attr :text, :string, required: true
  attr :field, :string, required: true
  attr :selected, :list, required: true
  attr :options, :list, required: true

  def filter_button(assigns) do
    ~H"""
    <div>
      <button class="btn btn-sm rouded-md font-medium flex items-center justify-center w-full" popovertarget={"filter-#{@text}"} style={"anchor-name: --anchor-#{@text};"}>
        <span><%= @text %>: <%= if length(@selected) > 0 do length(@selected) else "" end %></span>
        <span class="leading-none">&#8964;</span>
      </button>
      <ul class="dropdown menu rouded-box bg-base-100 shadow-sm" 
          popover id={"filter-#{@text}"} style={"anchor-name: --anchor-#{@text}"}>
        <%= for option <- @options do %>
          <% checked? = option in @selected %>
          <li class={if checked? do "text-success" else "" end}>
            <a phx-click="filter" phx-value-field={@field} phx-value-val={option}
                class="cursor-pointer flex justify-between items-center">
              <span><%= option %></span>
              <%= if checked? do %>
                <span>✔</span>
              <% end %>
            </a>
          </li>
        <% end %>
      </ul>
    </div>
    """
  end

  def apply_filters(%{assigns: %{base_list: base, filters: filters}} = socket) do
    filtered = Enum.filter(base, fn item -> 
      Enum.all?(filters, fn 
        {_filed, []} -> true
        {field, allowed_values} -> Map.get(item, field) in allowed_values
      end)
    end) 
    assign(socket, :visible, filtered)
  end
end
