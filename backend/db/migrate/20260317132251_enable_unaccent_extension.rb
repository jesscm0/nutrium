class EnableUnaccentExtension < ActiveRecord::Migration[7.0]
  def change
    # Ativa a extensão que permite ignorar acentos
    # por exemplo: pesquisar por nutricao e devolver "nutrição"
    enable_extension 'unaccent'
  end
end