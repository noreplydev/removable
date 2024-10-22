/* @my/ui is wrapper for tamagui. Any component in tamagui can be imported through @my/ui
use result = await API.get(url) or result = await API.post(url, data) to send requests
API.get/API.post will return a PendingResult, with properties like isLoaded, isError and a .data property with the result
if you call paginated apis, you will need to wait for result.isLoaded and look into result.data.items, since result.data is an object with the pagination.
Paginated apis return an object like: {"itemsPerPage": 25, "items": [...], "total": 20, "page": 0, "pages": 1}
*/

import {Protofy} from 'protolib/base'
import {Objects} from 'app/bundles/objects'
import {DataView, API, AdminPage, PaginatedDataSSR, useWorkspaceApiUrl, getWorkspaceApiUrl, useRedirectToEnviron } from 'protolib'
import { Tag } from '@tamagui/lucide-icons'
import { context } from "app/bundles/uiContext";
import { useRouter } from "next/router";

const Icons =  {}
const isProtected = Protofy("protected", {{protected}})
const {name, prefix} = Objects.{{_object}}.getApiOptions()
const apiUrl = prefix + name

Protofy("object", "{{_object}}")
Protofy("pageType", "admin")

export default {
    route: Protofy("route", "{{route}}"),
    component: ({pageState, initialItems, pageSession, extraData}:any) => {
        useRedirectToEnviron()
        const sourceUrl = useWorkspaceApiUrl(apiUrl)

        return (<AdminPage title="{{object}}" pageSession={pageSession}>
            <DataView
                rowIcon={Tag}
                sourceUrl={sourceUrl}
                initialItems={initialItems}
                numColumnsForm={1}
                name="{{object}}"
                model={Objects.{{_object}} } 
                pageState={pageState}
                icons={Icons}
            />
        </AdminPage>)
    }, 
    getServerSideProps: (context) => PaginatedDataSSR(getWorkspaceApiUrl(context.resolvedUrl, apiUrl), isProtected?Protofy("permissions", {{{permissions}}}):undefined)(context)
}