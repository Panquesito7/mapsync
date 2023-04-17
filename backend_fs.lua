
local function get_path(backend_def, chunk_pos)
    return backend_def.path .. "/chunk_" .. minetest.pos_to_string(chunk_pos) .. ".zip"
end

mapsync.register_backend_handler("fs", {
    save_chunk = function(backend_def, chunk_pos)
        return mapsync.serialize_chunk(chunk_pos, get_path(backend_def, chunk_pos))
    end,

    load_chunk = function(backend_def, chunk_pos, vmanip)
        return mapsync.deserialize_chunk(chunk_pos, get_path(backend_def, chunk_pos), vmanip)
    end,

    get_manifest = function(backend_def, chunk_pos)
        return mapsync.get_manifest(get_path(backend_def, chunk_pos))
    end,

    list_chunks = function(backend_def)
        local files = minetest.get_dir_list(backend_def.path, false)
        local chunks = {}
        for _, filename in ipairs(files) do
            if string.match(filename, "^[chunk_(].*[).zip]$") then
                local pos_str = string.gsub(filename, "chunk_", "")
                pos_str = string.gsub(pos_str, ".zip", "")

                local pos = minetest.string_to_pos(pos_str)
                table.insert(chunks, pos)
            end
        end
        return chunks
    end
})
