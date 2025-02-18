-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler  version: 0.9.3-alpha1
-- PostgreSQL version: 12.0
-- Project Site: pgmodeler.io
-- Model Author: ---


-- Database creation must be done outside a multicommand file.
-- These commands were put in this file only as a convenience.
-- -- object: new_database | type: DATABASE --
-- -- DROP DATABASE IF EXISTS new_database;
-- CREATE DATABASE new_database;
-- -- ddl-end --
-- 

-- object: public."user" | type: TABLE --
-- DROP TABLE IF EXISTS public."user" CASCADE;
CREATE TABLE public."user" (
	id serial NOT NULL,
	name varchar(255) NOT NULL,
	email varchar(255) NOT NULL,
	password varchar(255) NOT NULL,
	CONSTRAINT user_pk PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON TABLE public."user" IS E'Tabela de usuários';
-- ddl-end --
COMMENT ON COLUMN public."user".id IS E'Chave primária da tabela';
-- ddl-end --
COMMENT ON COLUMN public."user".name IS E'Nome do usuário';
-- ddl-end --
COMMENT ON COLUMN public."user".email IS E'Email do usuário';
-- ddl-end --
COMMENT ON COLUMN public."user".password IS E'Senha do usuário';
-- ddl-end --
ALTER TABLE public."user" OWNER TO postgres;
-- ddl-end --

-- object: public.asset | type: TABLE --
-- DROP TABLE IF EXISTS public.asset CASCADE;
CREATE TABLE public.asset (
	id serial NOT NULL,
	symbol varchar(255) NOT NULL,
	price decimal(10,2) NOT NULL DEFAULT 0.00,
	CONSTRAINT asset_pk PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON TABLE public.asset IS E'Tabela contendo os ativos da aplicação (Ações)';
-- ddl-end --
COMMENT ON COLUMN public.asset.id IS E'Chave primária da tabela';
-- ddl-end --
COMMENT ON COLUMN public.asset.symbol IS E'Símbolo do ativo negociado';
-- ddl-end --
COMMENT ON COLUMN public.asset.price IS E'Preço do ativo negociado';
-- ddl-end --
ALTER TABLE public.asset OWNER TO postgres;
-- ddl-end --

-- object: public.wallet | type: TABLE --
-- DROP TABLE IF EXISTS public.wallet CASCADE;
CREATE TABLE public.wallet (
	id serial NOT NULL,
	"userId" integer NOT NULL,
	CONSTRAINT wallet_pk PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON TABLE public.wallet IS E'Tabela que refere-se à carteira de ativos do usuário';
-- ddl-end --
COMMENT ON COLUMN public.wallet.id IS E'Chave primária da tabela';
-- ddl-end --
COMMENT ON COLUMN public.wallet."userId" IS E'Chave estrangeira que relaciona a carteira ao usuário dono';
-- ddl-end --
ALTER TABLE public.wallet OWNER TO postgres;
-- ddl-end --

-- object: public."order" | type: TABLE --
-- DROP TABLE IF EXISTS public."order" CASCADE;
CREATE TABLE public."order" (
	id serial NOT NULL,
	shares integer NOT NULL,
	price decimal(10,2) NOT NULL,
	"walletId" integer NOT NULL,
	"assetId" integer NOT NULL,
	CONSTRAINT order_pk PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON TABLE public."order" IS E'Tabela para armazenamento das ordens realizadas';
-- ddl-end --
COMMENT ON COLUMN public."order".id IS E'Chave primária da tabela';
-- ddl-end --
COMMENT ON COLUMN public."order".shares IS E'Quantidade de ativos na ordem';
-- ddl-end --
COMMENT ON COLUMN public."order".price IS E'Preço negociado do ativo na ordem';
-- ddl-end --
COMMENT ON COLUMN public."order"."walletId" IS E'Chave estrangeira que relaciona a ordem à carteira de um usuário';
-- ddl-end --
COMMENT ON COLUMN public."order"."assetId" IS E'Chave estrangeira que relaciona o ativo à ordem';
-- ddl-end --
ALTER TABLE public."order" OWNER TO postgres;
-- ddl-end --

-- object: public.wallet_asset | type: TABLE --
-- DROP TABLE IF EXISTS public.wallet_asset CASCADE;
CREATE TABLE public.wallet_asset (
	id serial NOT NULL,
	shares integer NOT NULL,
	"walletId" integer NOT NULL,
	"assetId" integer NOT NULL,
	CONSTRAINT wallet_asset_pk PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON TABLE public.wallet_asset IS E'Tabela intermediária que relaciona ativos dentro de uma carteira';
-- ddl-end --
COMMENT ON COLUMN public.wallet_asset.id IS E'Chave primária da tabela';
-- ddl-end --
COMMENT ON COLUMN public.wallet_asset.shares IS E'Campo que indica a quantidade de ativos presentes em uma carteira específica';
-- ddl-end --
COMMENT ON COLUMN public.wallet_asset."walletId" IS E'Chave estrangeira de relacionamento com a carteira dona do ativo';
-- ddl-end --
COMMENT ON COLUMN public.wallet_asset."assetId" IS E'Chave estrangeira que indica o ativo relacionado';
-- ddl-end --
ALTER TABLE public.wallet_asset OWNER TO postgres;
-- ddl-end --

-- object: fk_user_wallet | type: CONSTRAINT --
-- ALTER TABLE public.wallet DROP CONSTRAINT IF EXISTS fk_user_wallet CASCADE;
ALTER TABLE public.wallet ADD CONSTRAINT fk_user_wallet FOREIGN KEY ("userId")
REFERENCES public."user" (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --
COMMENT ON CONSTRAINT fk_user_wallet ON public.wallet  IS E'Chave estrangeira de relacionamento com o usuário à quem a carteira pertence';
-- ddl-end --


-- object: fk_order_wallet | type: CONSTRAINT --
-- ALTER TABLE public."order" DROP CONSTRAINT IF EXISTS fk_order_wallet CASCADE;
ALTER TABLE public."order" ADD CONSTRAINT fk_order_wallet FOREIGN KEY ("walletId")
REFERENCES public.wallet (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --
COMMENT ON CONSTRAINT fk_order_wallet ON public."order"  IS E'Chave estrangeira de relacionamento da ordem com a carteira';
-- ddl-end --


-- object: fk_order_asset | type: CONSTRAINT --
-- ALTER TABLE public."order" DROP CONSTRAINT IF EXISTS fk_order_asset CASCADE;
ALTER TABLE public."order" ADD CONSTRAINT fk_order_asset FOREIGN KEY ("assetId")
REFERENCES public.asset (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --
COMMENT ON CONSTRAINT fk_order_asset ON public."order"  IS E'Chave estrangeira de relacionamento da ordem com o ativo';
-- ddl-end --


-- object: fk_wallet_wallet_asset | type: CONSTRAINT --
-- ALTER TABLE public.wallet_asset DROP CONSTRAINT IF EXISTS fk_wallet_wallet_asset CASCADE;
ALTER TABLE public.wallet_asset ADD CONSTRAINT fk_wallet_wallet_asset FOREIGN KEY ("walletId")
REFERENCES public.wallet (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --
COMMENT ON CONSTRAINT fk_wallet_wallet_asset ON public.wallet_asset  IS E'Chave estrangeira de relacionamento entre a carteira';
-- ddl-end --


-- object: fk_asset_wallet_asset | type: CONSTRAINT --
-- ALTER TABLE public.wallet_asset DROP CONSTRAINT IF EXISTS fk_asset_wallet_asset CASCADE;
ALTER TABLE public.wallet_asset ADD CONSTRAINT fk_asset_wallet_asset FOREIGN KEY ("assetId")
REFERENCES public.asset (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --
COMMENT ON CONSTRAINT fk_asset_wallet_asset ON public.wallet_asset  IS E'Chave de relacionamento ao ativo';
-- ddl-end --



