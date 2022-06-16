create table traces
(
    transaction_hash varchar(66),
    transaction_index bigint,
    from_address varchar(42),
    to_address varchar(42),
    value numeric(38),
    input text,
    output text,
    trace_type varchar(16),
    call_type varchar(16),
    reward_type varchar(16),
    gas bigint,
    gas_used bigint,
    subtraces bigint,
    trace_address varchar(8192),
    error text,
    status int,
    block_timestamp timestamp,
    block_number bigint,
    block_hash varchar(66),
    trace_id text
) PARTITION BY RANGE (block_timestamp);

create table public.traces_template (LIKE public.traces);

alter table public.traces_template add constraint traces_pk primary key (trace_id);
create index traces_block_timestamp_index on public.traces_template (block_timestamp desc);
create index traces_from_address_block_timestamp_index on public.traces_template (from_address, block_timestamp desc);
create index traces_to_address_block_timestamp_index on public.traces_template (to_address, block_timestamp desc);

SELECT partman.create_parent(
    'public.traces',
    'block_timestamp',
    'native',
    'daily',
    p_template_table := 'public.traces_template',
    p_start_partition := '2015-1-1'
);
