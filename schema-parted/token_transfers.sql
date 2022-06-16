create table token_transfers
(
    token_address varchar(42),
    from_address varchar(42),
    to_address varchar(42),
    value numeric(78),
    transaction_hash varchar(66),
    log_index bigint,
    block_timestamp timestamp,
    block_number bigint,
    block_hash varchar(66)
) PARTITION BY RANGE (block_timestamp);

create table public.token_transfers_template (LIKE public.token_transfers);

alter table public.token_transfers_template add constraint token_transfers_pk primary key (transaction_hash, log_index);
create index token_transfers_block_timestamp_index on public.token_transfers_template (block_timestamp desc);
create index token_transfers_token_address_block_timestamp_index on public.token_transfers_template (token_address, block_timestamp desc);
create index token_transfers_from_address_block_timestamp_index on public.token_transfers_template (from_address, block_timestamp desc);
create index token_transfers_to_address_block_timestamp_index on public.token_transfers_template (to_address, block_timestamp desc);

SELECT partman.create_parent(
    'public.token_transfers',
    'block_timestamp',
    'native',
    'daily',
    p_template_table := 'public.token_transfers_template',
    p_start_partition := '2015-1-1'
);
