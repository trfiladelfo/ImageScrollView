ImageScrollView
===============

Componente carrossel de imagens carregadas da internet de forma assíncrona.

Exemplo de uso:

UIImageScrollView *imageView = [[UIImageScrollView alloc] initWithFrame:CGRectMake(5, 5, 200, 200)];

//Array de endereços das imagens

NSArray *images = [NSArray arrayWithObjects:@"http://placedog.com/400/300", @"http://placedog.com/400/300", @"http://placedog.com/400/300", @"http://placedog.com/400/300", @"http://placedog.com/400/300", @"http://placedog.com/400/300", nil];
imageView.images = images;

[self.view addSubview:imageView];

