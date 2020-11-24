/* AC2 DE BANCO DE DADOS */
/* LEONARDO DE OLIVEIRA CAMPOS RA: 200203 */
/* GABRIEL BARAN SANTOS BARBOSA - RA:200255 */

drop database if exists ac2;
create database ac2;
use ac2;

create table produto (
	prd_id					int		auto_increment		primary key,
    prd_nome				varchar(50)		not null,
    prd_precovenda			decimal(8,2),
    prd_tamanho				varchar(3),
    prd_marca				varchar(50),
    prd_fornecedor			varchar(50),
    prd_telefonefornecedor	varchar(15),
    prd_emailfornecedor		varchar(100)
)ENGINE = innodb;

create table cliente (
	clt_id			int		auto_increment		primary key,
    clt_nome		varchar(100)	not null,
    clt_cpf			varchar(11),
    clt_email		varchar(100),
    clt_endereco	varchar(100),
    clt_avaliacao	varchar(10) 	/* Péssimo, Ruim, Regular, Bom ou Excelente */
)ENGINE = innodb;

create table pedido (
	pdd_id			int		auto_increment		primary key,
    pdd_idcliente	int,
    pdd_data		date,
    
    constraint fk_cliente foreign key(pdd_idcliente) references cliente(clt_id)
)ENGINE = innodb;

create table itempedido (
	item_idpedido		int,
    item_idproduto		int,
    item_quantidade		int,
    itemprd_precovenda	decimal(8,2),
    
    constraint fk_pedido foreign key(item_idpedido) references pedido(pdd_id),
    constraint fk_produto foreign key(item_idproduto) references produto(prd_id)
)ENGINE = innodb;

insert into produto values
	(null, "Camiseta Polo", 39.99, "M", "Polo", "Outlet", "1512345678", "outlet@outlet.com.br"),
    (null, "Calça Jeans", 59.99, "44", "Levi's", "Outlet", "1512345678", "outlet@outlet.com.br"),
    (null, "Tênis", 109.99, "41", "Nike", "Outlet", "1512345678", "outlet@outlet.com.br"),
    (null, "Moletom", 99.99, "GG", "Adidas", "Outlet", "1512345678", "outlet@outlet.com.br"),
    (null, "Vestido", 49.99, "M", "Valentina", "Outlet", "1512345678", "outlet@outlet.com.br");
    
insert into cliente values
	(null, "José Batista Ferreira", "12345678901", "josebatista@hotmail.com", "Rua Orlando Silva, 288", "Bom"),
    (null, "Ademir Queimado", "29384750192", "ademirq@hotmail.com", "Rua Fransciso Antonio, 157", "Excelente"),
    (null, "Mario Toledo", "82736481720", "mariobos@gmail.com", "Rua Antonio Silva, 21", "Bom"),
    (null, "Vanessa Camargo", "99283774950", "vanvanc@gmail.com", "Rua Paula Ney, 47", "Regular"),
    (null, "Amélia Campos", "91827384019", "camposamelia@gmail.com", "Rua Souza Britto, 420", "Ruim");

insert into pedido values
	(null, 1, "2020-11-22"),
    (null, 2, "2020-11-14"),
    (null, 3, "2020-11-08"),
    (null, 4, "2020-11-07"),
    (null, 5, "2020-10-30");
    
insert into itempedido values
	(1, 1, 3, 39.99),
    (2, 2, 2, 59.99),
    (3, 3, 1, 109.99),
    (4, 4, 1, 99.99),
    (5, 5, 1, 49.99);
    
/* VIEWS */
    

/* Exibir os produtos mais caros ordenados pelo preço em ordem decrescente */

create view MaisCaros as
select prd_id, prd_nome, prd_precovenda precovenda from produto
	order by precovenda desc
    limit 5;
    
select * from MaisCaros;

/* Exibir os clientes em ordem alfabética */    

create view OrdemAlfab as
select clt_id, clt_nome nome, clt_email, clt_endereco from cliente
	order by nome asc
    limit 5;

select * from OrdemAlfab;

/* Exibir o valor total sobre os itens pedidos */

create view ItensPedidos as
select 	item_idproduto idproduto,itemprd_precovenda preco, item_quantidade quantidade,  (item_quantidade * itemprd_precovenda) as total from itempedido
	order by total desc
    limit 5;

select * from ItensPedidos;

/* PROCEDURES */

/* Adicionar um novo produto */

delimiter $

create procedure novoProduto (
	nome_prd 		varchar(60),
    preco_prd 		decimal(8,2),
    tamanho_prd 	varchar(3),
    marca_prd		varchar(60),
    fornecedor_prd 	varchar(100)
)
begin
	set @produto_id = (select prd_id from produto where prd_nome = nome_prd);
	insert into produto values (null, nome_prd, preco_prd, tamanho_prd, marca_prd, fornecedor_prd);
end$

delimiter ;

call novoProduto("Boné", 49.99, "M", "New Era", "Outlet");
select * from produto;

/* Triggers */

/* Garantir que o preço dos produtos não seja negativo */

delimiter $

create trigger checar_preco before insert on produto
	for each row
	begin
		if new.prd_precovenda < 0 then
			set new.prd_precovenda = null;
		end if;
	end$

delimiter ;



