baskets = Basket.create([{ name: 'Cesta de frutas' }, { name: 'Cesta de doces' }])

baskets.first.foods.create([{ name: 'Maçã' }, { name: 'Morango' }])
baskets.last.foods.create([{ name: 'Chocolate' }, { name: 'Doce de leite' }])