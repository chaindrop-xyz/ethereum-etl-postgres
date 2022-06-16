create table blocks
(
    timestamp timestamp,
    number bigint,
    hash varchar(66),
    parent_hash varchar(66),
    nonce varchar(42),
    sha3_uncles varchar(66),
    logs_bloom text,
    transactions_root varchar(66),
    state_root varchar(66),
    receipts_root varchar(66),
    miner varchar(42),
    difficulty numeric(38),
    total_difficulty numeric(38),
    size bigint,
    extra_data text,
    gas_limit bigint,
    gas_used bigint,
    transaction_count bigint,
    base_fee_per_gas bigint
) PARTITION BY RANGE (timestamp);

create table public.blocks_template (LIKE public.blocks);

alter table public.blocks_template add constraint blocks_pk primary key (hash);
create index blocks_timestamp_index on public.blocks_template (timestamp desc);
create unique index blocks_number_uindex on public.blocks_template (number desc);

SELECT partman.create_parent(
    'public.blocks',
    'timestamp',
    'native',
    'daily',
    p_template_table := 'public.blocks_template',
    p_start_partition := '2015-1-1'
);