create table logs
(
    log_index bigint,
    transaction_hash varchar(66),
    transaction_index bigint,
    address varchar(42),
    data text,
    topic0 varchar(66),
    topic1 varchar(66),
    topic2 varchar(66),
    topic3 varchar(66),
    block_timestamp timestamp,
    block_number bigint,
    block_hash varchar(66)
) PARTITION BY RANGE (block_timestamp);

create table public.logs_template (LIKE public.logs);

alter table public.logs_template add constraint logs_pk primary key (transaction_hash, log_index);
create index logs_block_timestamp_index on public.logs_template (block_timestamp desc);
create index logs_address_block_timestamp_index on public.logs_template (address, block_timestamp desc);

SELECT partman.create_parent(
    'public.logs',
    'block_timestamp',
    'native',
    'daily',
    p_template_table := 'public.logs_template',
    p_start_partition := '2015-1-1'
);