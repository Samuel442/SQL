USE DB_ecommerce

SELECT * FROM tb_cliente

SELECT * FROM tb_pedido

SELECT * FROM tb_item_pedido

-- Deletando registro
DELETE FROM tb_produto
WHERE id_cliente = 3;

-- Limpar tabela inteira
TRUNCATE TABLE tb_item_pedido;
