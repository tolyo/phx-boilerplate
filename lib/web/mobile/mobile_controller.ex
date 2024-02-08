defmodule Web.MobileController do
  use Web, :controller

  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, _params) do
    conn
    |> put_layout(html: {Web.LayoutView, :mobile_layout})
    |> MainLayout.content("""

        <div class="navbar">
          <div class="navbar-bg"></div>
          <div class="navbar-inner">
            <div class="title">Awesome App</div>
          </div>
        </div>

        <!-- Bottom Toolbar -->
        <div class="toolbar toolbar-bottom">
          <div class="toolbar-inner">
            <!-- Toolbar links -->
            <a href="#" class="link">Link 1</a>
            <a href="#" class="link">Link 2</a>
          </div>
        </div>

        <!-- Scrollable page content -->
        <div class="page-content">
          <p>Page content goes here</p>
          <button class="button" onclick="app.dialog.alert('Hello!')">Alert</button>
          <!-- Link to another page -->
          <a href="/about/">About app</a>
        </div>
      """
    )
  end

  @spec home(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def home(conn, params) do
    conn
    |> content("""
    <div class="navbar">
      <div class="navbar-bg"></div>
      <div class="navbar-inner">
        <div class="title">Awesome App</div>
      </div>
    </div>

    <!-- Bottom Toolbar -->

    <!-- Scrollable page content -->
    <div class="page-content">
      <p>Page content goes here</p>
      <button onclick="window.location.reload()">Reload</button>
      <!-- Link to another page -->
      <a href="/about/">About app</a>
    </div>
    """)
  end
end
