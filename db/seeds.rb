# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Tag.create([
  { name: '神社' },
  { name: '絶景' },
  { name: 'おしゃれ' },
  { name: '温泉' },
  { name: '博物館' }
])

   Category.create(name: "歴史")
   Category.create(name: "自然")
   Category.create(name: "文化・芸術")
   Category.create(name: "エンタメ・遊び")
   Category.create(name: "体験")
   Category.create(name: "グルメ")
   Category.create(name: "動物")
   Category.create(name: "伝統・イベント")