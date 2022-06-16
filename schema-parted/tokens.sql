create table tokens
(
    address varchar(42),
    name text,
    symbol text,
    decimals int(11),
    total_supply numeric(78),
    block_number bigint,
    block_hash varchar(66),
    block_timestamp timestamp
) PARTITION BY RANGE (block_timestamp);

create table public.tokens_template (LIKE public.tokens);

ALTER TABLE public.tokens_template add constraint tokens_pk primary key (address, block_number);
create index tokens_block_number_index on public.tokens_template (block_number desc);

SELECT partman.create_parent(
    'public.tokens',
    'block_timestamp',
    'native',
    'daily',
    p_template_table := 'public.logs_template',
    p_start_partition := '2015-1-1'
);