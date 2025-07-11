--|| ModulR ||--

--|| Interfaces ||--
export type Service = {
    Name: string,
    Initialize: () -> any,
    Destroy: () -> any,
    Client: {}?,
    Server: {}?,
    Shared: {}?
}

return nil
