module ApplicationHelper
  def default_meta_tags
    og_image = "#{request.base_url}#{asset_path('ogp.png')}"

    {
      site: "時間作るん",
      title: "習慣化サービス",
      reverse: true,
      charset: "utf-8",
      description: "時間作るんは、誰もが毎日必ずする習慣を手助けするサービスです",
      keywords: "習慣化",
      canonical: request.original_url,
      separator: "|",
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: "website",
        url: request.original_url,
        image: og_image,
        locale: "ja_JP"
      },
      twitter: {
        card: "summary_large_image",
        site: "@Z3MlmG659Z78990",
        image: og_image
      }
    }
  end

  def line_qrcode(url)
    qrcode = RQRCode::QRCode.new(url)

    qrcode.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 6,
      standalone: true,
      use_path: true
    ).html_safe
  end
end
