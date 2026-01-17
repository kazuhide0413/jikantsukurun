module ApplicationHelper
  def default_meta_tags
    {
      site: '時間作るん',
      title: '習慣化サービス',
      reverse: true,
      charset: 'utf-8',
      description: '時間作るんは、誰もが毎日必ずする習慣を手助けするサービスです',
      keywords: '習慣化',
      canonical: https://jikantsukurun.onrender.com/,
      separator: '|',
      og:{
        site_name: :site,
        title: :title,
        description: :description,
        type: 'website',
        url: https://jikantsukurun.onrender.com/,
        image: image_url('ogp.png'),
        local: 'ja-JP'
      },
      twitter: {
        card: 'summary_large_image',
        site: '@Z3MlmG659Z78990',
        image: image_url('ogp.png')
      }
    }
  end
end