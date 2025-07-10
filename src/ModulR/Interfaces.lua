--|| ModulR ||--

--|| Interfaces ||--
export type Service = {
    Name: string,
    Initialize: () -> any,
    Destroy: () -> any,
    Server: {}?,
    Client: {}?
}

return nil
