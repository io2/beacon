defmodule Beacon.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/BeaconCMS/beacon"
  @homepage_url "https://beaconcms.org"

  def project do
    [
      app: :beacon,
      version: @version,
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      name: "Beacon",
      homepage_url: @homepage_url,
      source_url: @source_url,
      description: """
      Open-source Content Management System (CMS) built with Phoenix LiveView. Faster render times to boost SEO performance, even for the most content-heavy pages.
      """,
      package: package(),
      deps: deps(),
      aliases: aliases(),
      docs: docs()
    ]
  end

  def application do
    [
      mod: {Beacon.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp package do
    [
      maintainers: ["Leandro Pereira", "Andrew Berrien"],
      licenses: ["MIT"],
      links: %{
        Changelog: "https://hexdocs.pm/beacon/#{@version}/changelog.html",
        GitHub: @source_url,
        Website: @homepage_url,
        DockYard: "https://dockyard.com"
      },
      files: ~w(lib priv .formatter.exs mix.exs CHANGELOG.md LICENSE.md)
    ]
  end

  defp deps do
    [
      # Overridable
      override_dep(:phoenix, "~> 1.7", "PHOENIX_VERSION", "PHOENIX_PATH"),
      override_dep(:phoenix_live_view, "~> 0.20", "PHOENIX_LIVE_VIEW_VERSION", "PHOENIX_LIVE_VIEW_PATH"),
      override_dep(:mdex, "~> 0.2", "MDEX_VERSION", "MDEX_PATH"),

      # Runtime
      {:accent, "~> 1.1"},
      {:ecto_sql, "~> 3.6"},
      {:ex_brotli, "~> 0.3"},
      # FIXME: multipart copy in ex_aws_s3 2.5.0
      {:ex_aws, "~> 2.4.0"},
      {:ex_aws_s3, "~> 2.4.0"},
      {:floki, ">= 0.30.0"},
      {:gettext, "~> 0.26"},
      {:hackney, "~> 1.16"},
      {:image, "~> 0.40"},
      {:jason, "~> 1.0"},
      {:oembed, "~> 0.4.1"},
      {:phoenix_ecto, "~> 4.4"},
      {:phoenix_html, "~> 4.0"},
      {:phoenix_html_helpers, "~> 1.0"},
      {:phoenix_pubsub, "~> 2.1"},
      {:postgrex, "~> 0.16"},
      {:safe_code, "~> 0.2"},
      {:solid, "~> 0.14"},
      {:tailwind, "~> 0.2"},
      {:igniter, "~> 0.3"},

      # Dev, Test, Docs
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:bandit, "~> 1.0", only: :dev, optional: true},
      {:phoenix_view, "~> 2.0", only: [:dev, :test]},
      {:ex_doc, "~> 0.29", only: :dev, runtime: false},
      {:esbuild, "~> 0.5", only: :dev},
      {:phoenix_live_reload, "~> 1.3", only: :dev},
      {:bypass, "~> 2.1", only: :test},
      {:phx_new, "~> 1.7", only: :test, runtime: false}
    ]
  end

  defp override_dep(dep, requirement, env_version, env_path) do
    cond do
      version = System.get_env(env_version) -> {dep, version, override: true}
      path = System.get_env(env_path) -> {dep, path: path, override: true}
      :default -> {dep, requirement}
    end
  end

  defp aliases do
    [
      setup: ["deps.get", "assets.setup", "assets.build"],
      dev: ["run --no-halt dev.exs"],
      "format.all": ["format", "cmd npm run format --prefix ./assets"],
      "format.all.check": [
        "format --check-formatted",
        "cmd npm run format-check --prefix ./assets"
      ],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.setup": [
        "tailwind.install --if-missing --no-assets",
        "esbuild.install --if-missing",
        "cmd npm install --prefix assets"
      ],
      "assets.build": ["esbuild cdn", "esbuild cdn_min", "esbuild tailwind_bundle"]
    ]
  end

  defp docs do
    [
      main: "Beacon",
      logo: "assets/images/beacon_logo.png",
      source_ref: "v#{@version}",
      source_url: @source_url,
      extra_section: "GUIDES",
      extras: extras(),
      groups_for_extras: groups_for_extras(),
      groups_for_modules: groups_for_modules(),
      groups_for_docs: [
        "Functions: Layouts": &(&1[:type] == :layouts),
        "Functions: Pages": &(&1[:type] == :pages),
        "Functions: Page Variants": &(&1[:type] == :page_variants),
        "Functions: Stylesheets": &(&1[:type] == :stylesheets),
        "Functions: Components": &(&1[:type] == :components),
        "Functions: Snippets": &(&1[:type] == :snippets),
        "Functions: Event Handlers": &(&1[:type] == :event_handlers),
        "Functions: Error Pages": &(&1[:type] == :error_pages),
        "Functions: Live Data": &(&1[:type] == :live_data),
        "Functions: Info Handlers": &(&1[:type] == :info_handlers)
      ],
      skip_undefined_reference_warnings_on: ["CHANGELOG.md"]
    ]
  end

  defp extras do
    ["CHANGELOG.md"] ++ Path.wildcard("guides/*/*.md")
  end

  defp groups_for_extras do
    [
      Introduction: ~r"guides/introduction/",
      Recipes: ~r"guides/recipes/",
      Troubleshoot: ~r"troubleshoot.md",
      Upgrading: ~r"guides/upgrading/"
    ]
  end

  defp groups_for_modules do
    [
      Execution: [
        Beacon.Router,
        Beacon.Loader,
        Beacon.Registry,
        Beacon.Migration
      ],
      Content: [
        Beacon.Content,
        Beacon.Content.Component,
        Beacon.Content.ComponentAttr,
        Beacon.Content.ComponentSlot,
        Beacon.Content.ComponentSlotAttr,
        Beacon.Content.ErrorPage,
        Beacon.Content.EventHandler,
        Beacon.Content.InfoHandler,
        Beacon.Content.Layout,
        Beacon.Content.LayoutEvent,
        Beacon.Content.LayoutSnapshot,
        Beacon.Content.LiveData,
        Beacon.Content.LiveDataAssign,
        Beacon.Content.Page,
        Beacon.Content.Page.Event,
        Beacon.Content.Page.Helper,
        Beacon.Content.PageEvent,
        Beacon.Content.PageSnapshot,
        Beacon.Content.PageVariant,
        Beacon.Content.Stylesheet,
        Beacon.Content.Snippets.Helper,
        Beacon.Template,
        Beacon.Template.HEEx,
        Beacon.Template.Markdown
      ],
      "Media Library": [
        Beacon.MediaLibrary,
        Beacon.MediaLibrary.Asset,
        Beacon.MediaLibrary.Provider,
        Beacon.MediaLibrary.Provider.Repo,
        Beacon.MediaLibrary.Provider.S3,
        Beacon.MediaLibrary.Provider.S3.Signed,
        Beacon.MediaLibrary.Provider.S3.Unsigned,
        Beacon.MediaTypes,
        Beacon.MediaLibrary.Processors.Default,
        Beacon.MediaLibrary.Processors.Image,
        Beacon.MediaLibrary.UploadMetadata
      ],
      Web: [
        Beacon.RuntimeCSS,
        Beacon.RuntimeJS,
        Beacon.RuntimeCSS.TailwindCompiler,
        Beacon.Web.BeaconAssigns
      ],
      Extensibility: [
        Beacon.Config,
        Beacon.Lifecycle,
        Beacon.Template.LoadMetadata,
        Beacon.Template.RenderMetadata,
        Beacon.Content.PageField,
        Beacon.MediaLibrary.AssetField
      ],
      Types: [
        Beacon.Types.Atom,
        Beacon.Types.Binary,
        Beacon.Types.Site,
        Beacon.Types.JsonArrayMap
      ],
      Exceptions: [
        Beacon.LoaderError,
        Beacon.AuthorizationError,
        Beacon.ParserError,
        Beacon.SnippetError,
        Beacon.Web.NotFoundError,
        Beacon.Web.ServerError,
        Beacon.RuntimeError,
        Beacon.ConfigError
      ]
    ]
  end
end
