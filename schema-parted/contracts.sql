create table contracts
(
    address varchar(42),
    bytecode text,
    function_sighashes text[],
    is_erc20 boolean,
    is_erc721 boolean,
    block_number bigint,
    block_hash varchar(66),
    block_timestamp timestamp
) PARTITION BY RANGE (block_timestamp);

create table public.contracts_template (LIKE public.contracts);

alter table public.contracts_template add constraint contracts_pk primary key (address, block_number);
create index contracts_block_number_index on public.contracts_template (block_number desc);
create index contracts_is_erc20_index on public.contracts_template (is_erc20, block_number desc);
create index contracts_is_erc721_index on public.contracts_template (is_erc721, block_number desc);

SELECT partman.create_parent(
    'public.contracts',
    'block_timestamp',
    'native',
    'daily',
    p_template_table := 'public.contracts_template',
    p_start_partition := '2015-1-1'
);